//
//  PerformView.swift
//  NavigationExample
//
//  Created by Sergey Balalaev on 25.01.2024.
//

import SwiftUI

import SwiftUI
import SUINavigation

enum PerformLoad: String, Equatable {
    case empty
    case navigation
    case full
    case sheet
    case sheetOptimized
}

private var boolIndex: Int = 0

extension Int: Identifiable {
    public var id: Int {
        self
    }
}

extension View {

    func manyModifiers2(_ performLoad: PerformLoad) -> some View {
        self
            .manyModifiers1(performLoad)
            .manyModifiers1(performLoad)
            .manyModifiers1(performLoad)
            .manyModifiers1(performLoad)
            .manyModifiers1(performLoad)
            .manyModifiers1(performLoad)
            .manyModifiers1(performLoad)
            .manyModifiers1(performLoad)
            .manyModifiers1(performLoad)
            .manyModifiers1(performLoad)
    }

    func manyModifiers1(_ performLoad: PerformLoad) -> some View {
        self
            .manyModifiers(performLoad)
            .manyModifiers(performLoad)
            .manyModifiers(performLoad)
            .manyModifiers(performLoad)
            .manyModifiers(performLoad)
            .manyModifiers(performLoad)
            .manyModifiers(performLoad)
            .manyModifiers(performLoad)
            .manyModifiers(performLoad)
            .manyModifiers(performLoad)
    }

    func manyModifiers(_ performLoad: PerformLoad) -> some View {
        ZStack{
            self
            switch performLoad {
            case .empty:
                EmptyView()
            case .navigation:
                let _ = boolIndex+=1
                let id = "Bool\(boolIndex)"
                EmptyView().navigation(isActive: .constant(false), id: id) {
                    BoolView()
                }
            case .full:
                EmptyView().fullScreenCover(item: .constant(Int?(nil))) { _ in
                    BoolView()
                }
            case .sheet:
                EmptyView().sheet(item: .constant(Int?(nil))) { _ in
                    BoolView()
                }
            case .sheetOptimized:
                EmptyView().background(
                    EmptyView().sheet(item: .constant(Int?(nil))) { _ in
                        BoolView()
                    }
                )
            }
        }
    }
}

struct PerformView: View {

    var startDate: Date

    @Binding
    var performLoad: PerformLoad

    let changeRepeatCount: Int = 1000

    @State
    private var isShow = false

    @State
    private var stringForFirst: String? = nil

    @Environment(\.isChange)
    private var isChange

    @State
    private var changeRepeatRest: Int = 0
    @State
    private var changeRepeatLast: Int = 0

    @Environment(\.presentationMode)
    private var presentationMode

    @State
    private var startChangeDate = Date()
    @State
    private var stopChangeDate = Date()

    @State
    private var oneTestPerformLoad: PerformLoad? = nil

    var body: some View {
        VStack {
            Text("This is Perform with \(performLoad.rawValue)")
            Text("Time to change: \(stopChangeDate.timeIntervalSince(startChangeDate) * 1000) msec.")

            HStack {
                Button("to First") {
                    stringForFirst = "Big"
                }
                Button("to Perform") {
                    startChangeDate = Date()
                    oneTestPerformLoad = performLoad
                }
            }
            Button("to change") {
                startChangeDate = Date()
                stopChangeDate = Date()
                isChange.wrappedValue.toggle()
            }
            Button("repeat times: \(changeRepeatCount)") {
                startChangeRepeat()
            }
            Button("dismiss") {
                presentationMode.wrappedValue.dismiss()
            }

            if isChange.wrappedValue {
                Text("This screen is changed")
            } else {
                Text("Waitting changes")
            }
            Text("Rest changes: \(changeRepeatRest) of \(changeRepeatCount) times")
            let _ = boolIndex = 0
        }
        .padding()
        .onChange(of: isChange.wrappedValue) { _ in
            stopChangeDate = Date()
        }
        .manyModifiers2(performLoad)
        .navigation(item: $stringForFirst) { stringValue in
            FirstView(string: stringValue)
        }
        .navigation(item: $oneTestPerformLoad) { _ in
            PerformView(startDate: startChangeDate, performLoad: $performLoad)
        }
        .onAppear{
            startChangeDate = startDate
            stopChangeDate = Date()
        }
    }

    func startChangeRepeat() {
        startChangeDate = Date()
        stopChangeDate = Date()
        changeRepeatRest = changeRepeatCount
        changeRepeat()
    }

    func changeRepeat() {
        if changeRepeatRest > 0 {
            Task { @MainActor in
                changeRepeatRest -= 1
                changeRepeat()
            }
        } else {
            stopChangeDate = Date()
        }
    }


}
