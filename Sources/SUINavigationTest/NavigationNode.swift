//
//  NavigationNode.swift
//
//
//  Created by Sergey Balalaev on 26.12.2023.
//

import SUINavigation

extension NavigationNode: Comparable {
    public static func < (lhs: NavigationNode, rhs: NavigationNode) -> Bool {
        lhs.id < rhs.id
    }

    public static func == (lhs: NavigationNode, rhs: NavigationNode) -> Bool {
        lhs.id == rhs.id && lhs.check(with: rhs) == nil
    }

    public static func > (lhs: NavigationNode, rhs: NavigationNode) -> Bool {
        lhs.id > rhs.id
    }
}

extension NavigationNode {

    public var name: String {
        id == Self.rootId ? "root" : "'\(id)'"
    }

    public static let rootId = ""

    public static func createRoot() -> NavigationNode {
        NavigationNode(id: rootId, params: [], available: .mock)
    }

    /// Return a failure meesage if has difference with `reference` nodes else return `nil`.
    public func check(with reference: NavigationNode, hasCheckingOrder: Bool = false) -> String? {
        var failureResult = ""
        var failuresCount = 0

        check(with: reference, level: 1, hasCheckingOrder: hasCheckingOrder, failureResult: &failureResult, failuresCount: &failuresCount)

        if failuresCount > 0 {
            return "\(failuresCount) differences from the reference were found:\n" + failureResult
        } else {
            return nil
        }
    }

    private func check(
        with reference: NavigationNode,
        level: Int,
        hasCheckingOrder: Bool = false,
        failureResult: inout String,
        failuresCount: inout Int)
    {
        if id != reference.id {
            failuresCount += 1
            failureResult += "\(failuresCount). Has different identifiers on level \(level). Actual '\(id)' expected '\(reference.id)'.\n"
        }
        if viewType != reference.viewType {
            failuresCount += 1
            let viewTypeString = viewType ?? "nil"
            let referenceViewTypeString = reference.viewType ?? "nil"
            failureResult += "\(failuresCount). The \(name) node has different view type on level \(level). Actual '\(viewTypeString)' expected '\(referenceViewTypeString)'.\n"
        }
        NavigationNodeParameter.check(
            params: params,
            referenceParams: reference.params,
            hasCheckingOrder: hasCheckingOrder,
            failureResult: &failureResult,
            failuresCount: &failuresCount,
            nodeId: id,
            level: level
        )
        if available != reference.available {
            failuresCount += 1
            failureResult += "\(failuresCount). The \(name) node has different available property on level \(level). Actual '\(available)' expected '\(reference.available)'.\n"
        }
        if attributes != reference.attributes {
            failuresCount += 1
            failureResult += "\(failuresCount). The \(name) node has different attributes property on level \(level). Actual '\(attributes)' expected '\(reference.attributes)'.\n"
        }

        if hasCheckingOrder {
            if checkChildrenCount(with: reference, level: level, failureResult: &failureResult, failuresCount: &failuresCount) {
                for index in 0..<children.count {
                    children[index].check(
                        with: reference.children[index],
                        level: level + 1,
                        failureResult: &failureResult,
                        failuresCount: &failuresCount)
                }
            }
        } else {
            checkChildrenCount(with: reference, level: level, failureResult: &failureResult, failuresCount: &failuresCount)
            var referenceChildren = reference.children
            for child in children {
                var index = 0
                var isNotFound = true
                while index < referenceChildren.count {
                    // this case can not detect double id's from one node
                    if child.id == referenceChildren[index].id {
                        child.check(
                            with: referenceChildren.remove(at: index),
                            level: level + 1,
                            failureResult: &failureResult,
                            failuresCount: &failuresCount)
                        isNotFound = false
                        break
                    } else {
                        index += 1
                    }
                }
                if isNotFound {
                    failuresCount += 1
                    failureResult += "\(failuresCount). In the \(name) node not found сhild with id '\(child.id)' on level \(level). From this level we have: \(reference.children.map{ $0.id }).\n"
                }
            }
        }
    }

    @discardableResult
    private func checkChildrenCount(
        with reference: NavigationNode,
        level: Int,
        failureResult: inout String,
        failuresCount: inout Int
    ) -> Bool {
        if children.count != reference.children.count {
            failuresCount += 1
            failureResult += "\(failuresCount). The \(name) node has different сhildren count on level \(level). Actual '\(children.count)' expected '\(reference.children.count)'.\n"
            return false
        } else {
            return true
        }
    }

}
