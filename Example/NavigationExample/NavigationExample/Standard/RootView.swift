//
//  RootView.swift
//  NavigationExample
//
//  Created by Sergey Balalaev on 16.11.2023.
//

import SwiftUI
import SUINavigation

protocol RootViewModelProtocol: ObservableObject {
    var stringForFirst: String? {set get}
    var numberForSecond: Int? {set get}
    var performStartDate: Date? {set get}
    var performLoad: PerformLoad {set get}

    static var initCount: Int {get}
    static var deinitCount: Int {get}
}

final class RootViewModel: RootViewModelProtocol {

    @Published
    var stringForFirst: String? = nil

    @Published
    var numberForSecond: Int? = nil

    @Published
    var performStartDate: Date? = nil
    @Published
    var performLoad: PerformLoad = .empty

    static var initCount: Int = 0
    static var deinitCount: Int = 0

    init(){
        Self.initCount += 1
    }

    deinit {
        Self.deinitCount += 1
    }
}

struct RootView<ViewModel: RootViewModelProtocol>: View {
    @StateObject
    private var viewModel: ViewModel

    @State
    private var isBoolShowed: Bool = false

    init() where ViewModel == RootViewModel {
        _viewModel = StateObject(wrappedValue: RootViewModel())
    }

    var body: some View {
        ZStack{
            VStack {
                Text("This is Main")
                Button("to First with Hi") {
                    viewModel.stringForFirst = "Hi"
                }
                Button("to Second with 11") {
                    viewModel.numberForSecond = 11
                }
                Button("to Bool") {
                    isBoolShowed = true
                }
                HStack {
                    Button("to Perform") {
                        viewModel.performStartDate = Date()
                    }
                    Text(" with: ")
                }
                HStack {
                    Button("Empty>") {
                        viewModel.performLoad = .empty
                    }
                    Button("Nav>") {
                        viewModel.performLoad = .navigation
                    }
                    Button("NavItem>") {
                        viewModel.performLoad = .navigationItem
                    }
                    Button("Full>") {
                        viewModel.performLoad = .full
                    }
                    Button("Sh>") {
                        viewModel.performLoad = .sheet
                    }
                    Button("ShOpt>") {
                        viewModel.performLoad = .sheetOptimized
                    }
                }
                HStack {
                    Text("VM init count: \(ViewModel.initCount)")
                    Text(", ")
                    Text("VM deinit count: \(ViewModel.deinitCount)")
                }
            }
        }
        .padding()
        .navigation(item: $viewModel.stringForFirst/*, id: "First"*/) { stringValue in
            FirstView(string: stringValue)
        }
        .navigationAction(item: $viewModel.numberForSecond) { numberValue in
            SecondView(number: numberValue, numberFromParent: $viewModel.numberForSecond)
        }
        .navigationAction(isActive: $isBoolShowed){
            BoolView()
        }
        .navigation(item: $viewModel.performStartDate){ startDate in
            PerformView(startDate: startDate, performLoad: $viewModel.performLoad)
        }
    }
}

#if DEBUG

final class RootViewModelMock: RootViewModelProtocol {
    @Published
    var stringForFirst: String?

    @Published
    var numberForSecond: Int?

    @Published
    var performStartDate: Date? = nil
    @Published
    var performLoad: PerformLoad = .empty

    static var initCount: Int = 0
    static var deinitCount: Int = 0

    init(){
        Self.initCount += 1
    }

    deinit {
        Self.deinitCount += 1
    }
}

extension RootView {
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    init(isBoolShowed: State<Bool>) where ViewModel == RootViewModel {
        _viewModel = StateObject(wrappedValue: RootViewModel())
        _isBoolShowed = isBoolShowed
    }
}

#endif
