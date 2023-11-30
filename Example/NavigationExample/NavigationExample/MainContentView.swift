//
//  MainContentView.swift
//  NavigationExample
//
//  Created by Sergey Balalaev on 16.11.2023.
//

import SwiftUI
import SUINavigation

private struct MainViewIsChangeShowedKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var isChange: Binding<Bool> {
        get { self[MainViewIsChangeShowedKey.self] }
        set { self[MainViewIsChangeShowedKey.self] = newValue }
    }
}

protocol MainViewModelProtocol: ObservableObject {
    var stringForFirst: String? {set get}
    var numberForSecond: Int? {set get}
}

final class MainViewModel: MainViewModelProtocol {

    @Published
    var stringForFirst: String? = nil

    @Published
    var numberForSecond: Int? = nil
}

struct MainContentView<ViewModel: MainViewModelProtocol>: View {
    @StateObject
    private var viewModel: ViewModel

    @State
    private var isBoolShowed: Bool = false

    init() where ViewModel == MainViewModel {
        _viewModel = StateObject(wrappedValue: MainViewModel())
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
            }
        }
        .padding()
        .navigation(item: $viewModel.stringForFirst) { stringValue in
            FirstView(string: stringValue)
        }
        .navigationAction(item: $viewModel.numberForSecond) { numberValue in
            SecondView(number: numberValue)
        }
        .navigationAction(isActive: $isBoolShowed){
            BoolView()
        }
    }
}

#if DEBUG

final class MainViewModelMock: MainViewModelProtocol {
    @Published
    var stringForFirst: String?

    @Published
    var numberForSecond: Int?
}

extension MainContentView {
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    init(isBoolShowed: State<Bool>) where ViewModel == MainViewModel {
        _viewModel = StateObject(wrappedValue: MainViewModel())
        _isBoolShowed = isBoolShowed
    }
}

#endif
