//
//  MainView.swift
//  NavigationExample
//
//  Created by Sergey Balalaev on 28.09.2023.
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

struct MainView: View {

    @State
    private var isRootMessageShowed: Bool = false

    @State
    private var isChange: Bool = false

    @State
    private var isRoot: Bool = true

    @OptionalEnvironmentObject
    private var navigationStorage: NavigationStorage?

    var body: some View {
        NavigationViewStorage{
            ZStack{
                if isChange {
                    Color.green.ignoresSafeArea()
                } else {
                    Color.yellow.ignoresSafeArea()
                }
                VStack{
                    MainContentView()
                        .navigationTitle(isRoot ? isChange ? "This screen is changed" : "Waitting changes" : "Back")
                        .navigationStorage(isRoot: $isRoot)

                    Button("to Root") {
                        navigationStorage?.popToRoot()
                    }
                }
            }
        }
        .alert(isPresented: $isRootMessageShowed) {
            Alert(title: Text("This is Root View"), message: nil, dismissButton: .default(Text("OK")))
        }
        .environment(\.isChange, $isChange)
        .onChange(of: isRoot) { value in
            Task {
                // Delay the task by 0.01 second:
                try await Task.sleep(nanoseconds: 1_0_000_000)
                isRootMessageShowed = value
            }
        }
    }
}

struct MainTabView: View {

    @State
    private var isChange: Bool = false

    @State
    private var isRoot: Bool = true

    var body: some View {
        NavigationViewStorage{
            ZStack(alignment: .bottom) {
                TabView() {
                    MainContentView()
                        .navigationStorage(isRoot: $isRoot)
                        .tabItem{
                            Text("Main Tab")
                        }

                    FirstView(string: "TabBar")
                        .tabItem{
                            Text("First Tab")
                        }
                    SecondView(number: 120)
                        .tabItem{
                            Text("Second Tab")
                        }
                    BoolView()
                        .tabItem{
                            Text("Bool Tab")
                        }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(isRoot ? isChange ? "This screen is changed" : "Waitting changes" : "Back")
        }
        .environment(\.isChange, $isChange)
    }
}

#Preview {
    MainView()
}
