//
//  ContentView.swift
//  Simple
//
//  Created by Sergey Balalaev on 07.11.2023.
//

import SwiftUI
import SUINavigation

struct RootView: View {
    // True value trigger navigation transition to FirstView
    @State
    private var isShowingFirst: Bool = false

    var body: some View {
        NavigationStorageView{
            VStack {
                Text("Root")
                Button("to First"){
                    isShowingFirst = true
                }
            }.navigationAction(isActive: $isShowingFirst){
                FirstView()
            }
        }
    }
}

struct FirstView: View {
    // Not null value trigger navigation transition to SecondView with this value, nil value to dissmiss to this View.
    @State
    private var optionalValue: Int? = nil

    var body: some View {
        VStack(spacing: 0) {
            Text("First")
            Button("to Second"){
                optionalValue = 777
            }
        }.navigationAction(item: $optionalValue, id: "second", paramName: "value"){ item in
            // item is unwrapped optionalValue where can used by SecondView
            SecondView(value: item)
        }
    }
}

struct SecondView: View {

    @State
    private var value: Int
    @State
    private var isShowingLast: Bool = false

    init(value: Int) {
        _value = State(wrappedValue: value)
    }

    var body: some View {
        VStack(spacing: 0) {
            Text("Second")
            Text("\(value)")
            Button("to Last"){
                isShowingLast = true
            }
        }.navigationAction(isActive: $isShowingLast, id: "last"){
            SomeView(secondValue: $value)
        }
    }
}

struct SomeView: View {
    @Binding
    var secondValue: Int
    // This optional everywhere, because in a test can use NavigationView without navigationStorage object
    @OptionalEnvironmentObject
    private var navigationStorage: NavigationStorage?

    // Standard feature of a dissmiss works too. Swipe to right works too.
    @Environment(\.presentationMode)
    private var presentationMode

    var body: some View {
        Button("Go to First") {
            // You should use struct for navigate, because it determinate without id
            navigationStorage?.popTo(FirstView.self)
        }
        Button("Go to SecondView") {
            // You should use id for navigate to SecondView, because it determinate as id
            secondValue = 10
            navigationStorage?.popTo("second")
        }
        Button("Go to Root") {
            navigationStorage?.popToRoot()
        }
        Button("Skip First") {
            navigationStorage?.skip(FirstView.self)
        }
        Button("Skip Second") {
            navigationStorage?.skip("second")
        }
    }
}
