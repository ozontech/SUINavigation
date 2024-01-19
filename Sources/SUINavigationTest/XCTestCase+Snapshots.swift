//
//  XCTestCase+Snapshots.swift
//
//
//  Created by Sergey Balalaev on 26.12.2023.
//

import XCTest
import SwiftUI
import SUINavigation

public extension XCTestCase {

    static let snapshotsDirName = "__Snapshots__"

    func rootNode(for view: any View, analyser: NavigationNodeAnalyserProtocol, mock: NavigationMockStore? = nil, isRecursive: Bool = false) -> NavigationNode {
        return analyser.searchNodes(for: view, isRecursive: isRecursive)
    }

    func rootNode(for view: any View, mock: NavigationMockStore? = nil, isRecursive: Bool = false) -> NavigationNode {
        // default is static analyser
        let staticAnalyser = NavigationNodeStaticAnalyser(mock: mock)
        return rootNode(for: view, analyser: staticAnalyser, mock: mock, isRecursive: isRecursive)
    }

    @inline(__always) func assertSnapshot<V: View>(
        _ view: V,
        mock: NavigationMockStore? = nil,
        snapshotDirectory: String? = nil,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) throws {
        // default is static analyser
        let staticAnalyser = NavigationNodeStaticAnalyser(mock: mock)
        let rootNode = rootNode(for: view, analyser: staticAnalyser, mock: mock, isRecursive: true)

        if staticAnalyser.failuresCount > 0 {
            XCTFail("Static analyser found issues: \n\n\(staticAnalyser.failureResult)", file: file, line: line)
        }

        let fileUrl = URL(fileURLWithPath: "\(file)", isDirectory: false)
        let fileName = fileUrl.deletingPathExtension().lastPathComponent

        let snapshotDirectoryUrl = snapshotDirectory.map { URL(fileURLWithPath: $0, isDirectory: true) }
            ?? fileUrl
            .deletingLastPathComponent()
            .appendingPathComponent(Self.snapshotsDirName)
            .appendingPathComponent(fileName)

        let snapshotFileUrl = snapshotDirectoryUrl
            .appendingPathComponent("\(testName.replacingOccurrences(of: "()", with: "")).json")

        let fileManager = FileManager.default
        try fileManager.createDirectory(at: snapshotDirectoryUrl, withIntermediateDirectories: true)



        guard fileManager.fileExists(atPath: snapshotFileUrl.path) else {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
            let data = try encoder.encode(rootNode)
            try data.write(to: snapshotFileUrl)

            XCTFail("No reference was found on disk. Automatically saved snapshot with path '\(snapshotFileUrl.path)'. Re-run '\(testName)' to test against the newly-recorded snapshot.", file: file, line: line)

            return
        }

        let data = try Data(contentsOf: snapshotFileUrl)
        let reference = try JSONDecoder().decode(NavigationNode.self, from: data)

        if let stringFailure = rootNode.check(with: reference) {
            XCTFail("Snapshot checker found issues: \n\n\(stringFailure)", file: file, line: line)
        }
    }

    @inline(__always) func assertItemsSnapshot<V: View>(
        _ view: V,
        mock: NavigationMockStore? = nil,
        hasDuplicationChecking: Bool = true,
        snapshotDirectory: String? = nil,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) throws {
        // default is static analyser
        let staticAnalyser = NavigationNodeStaticAnalyser(mock: mock)
        let rootNode = rootNode(for: view, analyser: staticAnalyser, mock: mock, isRecursive: true)

        if staticAnalyser.failuresCount > 0 {
            XCTFail("Static analyser found issues: \n\n\(staticAnalyser.failureResult)", file: file, line: line)
        }

        let items = rootNode.createMergedTestItems()

        if hasDuplicationChecking {
            if let stringFailure = NavigationNodeTestItem.checkDuplication(items) {
                XCTFail(stringFailure, file: file, line: line)
            }
        }

        let fileUrl = URL(fileURLWithPath: "\(file)", isDirectory: false)
        let fileName = fileUrl.deletingPathExtension().lastPathComponent

        let snapshotDirectoryUrl = snapshotDirectory.map { URL(fileURLWithPath: $0, isDirectory: true) }
            ?? fileUrl
            .deletingLastPathComponent()
            .appendingPathComponent(Self.snapshotsDirName)
            .appendingPathComponent(fileName)
            .appendingPathComponent(testName.replacingOccurrences(of: "()", with: ""))

        let fileManager = FileManager.default

        try fileManager.createDirectory(at: snapshotDirectoryUrl, withIntermediateDirectories: true)

        let fileNames = try fileManager.contentsOfDirectory(at: snapshotDirectoryUrl, includingPropertiesForKeys: nil)

        guard fileNames.count > 0 else {

            let encoder = JSONEncoder()
            encoder.outputFormatting = [.sortedKeys, .prettyPrinted]

            for item in items {
                let data = try encoder.encode(item)
                var snapshotFileUrl = snapshotDirectoryUrl.appendingPathComponent(item.name + ".json")
                var index = 1
                while fileManager.fileExists(atPath: snapshotFileUrl.path) {
                    snapshotFileUrl = snapshotDirectoryUrl.appendingPathComponent(item.name + "\(index).json")
                    index += 1
                }
                try data.write(to: snapshotFileUrl)
            }

            XCTFail("No reference was found on disk. Automatically saved snapshot with path '\(snapshotDirectoryUrl.path)'. Re-run '\(testName)' to test against the newly-recorded snapshot.", file: file, line: line)

            return
        }

        var referenceItems: [NavigationNodeTestItem] = []

        for fileName in fileNames {
            if fileName.lastPathComponent.hasSuffix(".json") {
                let data = try Data(contentsOf: fileName)
                let referenceItem = try JSONDecoder().decode(NavigationNodeTestItem.self, from: data)
                referenceItems.append(referenceItem)
            }
        }

        if let stringFailure = NavigationNodeTestItem.check(items, with: referenceItems, hasDuplicationChecking: hasDuplicationChecking) {
            XCTFail("Snapshot checker found issues: \n\n\(stringFailure)", file: file, line: line)
        }
    }

}
