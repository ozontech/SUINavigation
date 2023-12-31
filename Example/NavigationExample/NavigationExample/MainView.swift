//
//  MainView.swift
//  NavigationExample
//
//  Created by Sergey Balalaev on 28.09.2023.
//

import SwiftUI
import SUINavigation

struct MainView: View {

    @State
    private var isRootMessageShowed: Bool = false

    @State
    private var isChange: Bool = false

    @State
    private var isRoot: Bool = true

    @OptionalEnvironmentObject
    private var navigationStorage: NavigationStorage?

    private let isModular = ProcessInfo.processInfo.arguments.contains("-Modular")

    @ViewBuilder
    var rootView: some View {
        if isModular {
            ModularRootView()
        } else {
            RootView()
        }
    }

    var body: some View {
        NavigationViewStorage{
            ZStack{
                if isChange {
                    Color.green.ignoresSafeArea()
                } else {
                    Color.yellow.ignoresSafeArea()
                }
                VStack{
                    rootView
                        .navigationTitle(isRoot ? isChange ? "This screen is changed" : "Waitting changes" : "Back")
                        .navigationStorage(isRoot: $isRoot)

                    Button("to Root") {
                        navigationStorage?.popToRoot()
                    }
                }
            }.navigationStorageBinding(for: Destination.self) { destination in
                destination.view
            }
        }
        .alert(isPresented: $isRootMessageShowed) {
            Alert(title: Text("This is Root View"), message: nil, dismissButton: .default(Text("OK")))
        }
        .environment(\.isChange, $isChange)
        .onChange(of: isRoot) { value in
            if isChange == false {
                Task {
                    // Delay the task by 0.01 second:
                    try await Task.sleep(nanoseconds: 1_0_000_000)
                    isRootMessageShowed = value
                }
            }
        }
    }
}

#Preview {
    MainView()
}
