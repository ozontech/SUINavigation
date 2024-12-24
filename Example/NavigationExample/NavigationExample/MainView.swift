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

    @Environment(\.viewMode)
    private var viewMode
    @Environment(\.modelMode)
    private var modelMode

    @ViewBuilder
    var rootView: some View {
        switch modelMode.wrappedValue {
        case .standard:
            RootView()
        case .modular:
            ModularRootView()
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

                    HStack {
                        Button("to Root") {
                            navigationStorage?.popToRoot()
                        }
                        Button("to change") {
                            isChange.toggle()
                        }
                    }
                    HStack {
                        Text("viewMode: \(viewMode.wrappedValue.rawValue)")
                        Button("ChangeVM") {
                            viewMode.wrappedValue.next()
                        }
                    }
                    HStack {
                        Text("modelMode: \(modelMode.wrappedValue.rawValue)")
                        Button("ChangeMM") {
                            modelMode.wrappedValue.next()
                        }
                    }
                }
            }.navigationStorageBinding(for: Destination.self) { destination in
                destination.view
            }.navigationStorageBinding{ (value: ReplaceValue) in
                switch value {
                case .replace(let string):
                    ReplaceView(string: string)
                }
            }
        }
        .alert(isPresented: $isRootMessageShowed) {
            Alert(title: Text("This is Root View"), message: nil, dismissButton: .default(Text("OK")))
        }
        .environment(\.isChange, $isChange)
        .onChange(of: isRoot) { value in
#warning("So it's hack for test success. Needs research way navigation can broken without that. Any times this reproduced by Skip tests or Replase tets with iOS 18")
            if isChange == false {
                Task {
                    // Delay the task by 0.01 second:
                    try await Task.sleep(nanoseconds: 1_0_000_000)
                    Task { @MainActor in
                        isRootMessageShowed = value
                    }
                }
            }
        }
    }
}

#Preview {
    MainView()
}
