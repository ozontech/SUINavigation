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

class MainViewModel: ObservableObject {

    @Published
    var stringForFirst: String? = nil

    @Published
    var numberForSecond: Int? = nil
}

struct MainContentView: View {
    @StateObject
    private var viewModel = MainViewModel()

    @State
    private var isBoolShowed: Bool = false

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
