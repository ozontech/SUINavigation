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

struct MainView: View {

    @StateObject
    private var viewModel = MainViewModel()

    @OptionalEnvironmentObject
    var navigationStorage: NavigationStorage?

    @State
    private var isRoot: Bool = true

    @State
    private var isBoolShowed: Bool = false

    @State
    private var isRootMessageShowed: Bool = false

    @State
    private var isChange: Bool = false

    var body: some View {
        NavigationViewStorage{
            ZStack{
                if isChange {
                    Color.green.ignoresSafeArea()
                } else {
                    Color.yellow.ignoresSafeArea()
                }
                VStack {
                    Text("This is Main")
                    if isChange {
                        //Text("This screen is changed")
                    } else {
                        Image(systemName: "globe")
                            .imageScale(.large)
                        //Text("Waitting changes")
                    }
                    Button("to First with Hi") {
                        viewModel.stringForFirst = "Hi"
                    }
                    Button("to Second with 11") {
                        viewModel.numberForSecond = 11
                    }
                    Button("to Bool") {
                        isBoolShowed = true
                    }
                    Button("to Root") {
                        navigationStorage?.popToRoot()
                    }
                }
            }
            .padding()
            .navigationTitle(isRoot ? isChange ? "This screen is changed" : "Waitting changes" : "Back")
            .navigation(item: $viewModel.stringForFirst) { stringValue in
                FirstView(string: stringValue)
            }
            .navigationAction(item: $viewModel.numberForSecond) { numberValue in
                SecondView(number: numberValue)
            }
            .navigationAction(isActive: $isBoolShowed){
                BoolView()
            }
            .navigationStorage(isRoot: $isRoot)
            .onChange(of: isRoot) { value in
                Task {
                    // Delay the task by 0.01 second:
                    try await Task.sleep(nanoseconds: 1_0_000_000)
                    isRootMessageShowed = value
                }
            }
        }
        .alert(isPresented: $isRootMessageShowed) {
            Alert(title: Text("This is Root View"), message: nil, dismissButton: .default(Text("OK")))
        }
        .environment(\.isChange, $isChange)
    }
}

#Preview {
    MainView()
}
