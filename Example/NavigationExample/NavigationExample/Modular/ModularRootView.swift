//
//  ModularRootView.swift
//  NavigationExample
//
//  Created by Sergey Balalaev on 04.12.2023.
//

import SwiftUI
import SUINavigation

struct ModularRootView<ViewModel: RootViewModelProtocol>: View {
    @StateObject
    private var viewModel: ViewModel

    @State
    private var isBoolShowed: Bool = false

    @Environment(\.isChange)
    private var isChange

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
                Button("to Circular") {
                    viewModel.rootVM = RootViewModel()
                }
                HStack {
                    Text("VM init count: \(ViewModel.initCount), VM deinit count: \(ViewModel.deinitCount)")
                }
            }
        }
        .padding()
        .navigation(item: $viewModel.stringForFirst) { stringValue in
            Destination.first(stringValue)
        }
        .navigationAction(item: $viewModel.numberForSecond, id: Destination.second) { numberValue in
            Destination.second(numberValue, $viewModel.numberForSecond)
        }
        .navigationAction(isActive: $isBoolShowed) {
            Destination.bool
        }
        .navigation(item: $viewModel.rootVM) { vm in
            Destination.root(vm: vm)
        }
    }
}

#if DEBUG

extension ModularRootView {
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    init(isBoolShowed: State<Bool>) where ViewModel == RootViewModel {
        _viewModel = StateObject(wrappedValue: RootViewModel())
        _isBoolShowed = isBoolShowed
    }
}

#endif
