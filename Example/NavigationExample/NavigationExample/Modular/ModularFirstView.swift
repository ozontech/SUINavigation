//
//  ModularFirstView.swift
//  NavigationExample
//
//  Created by Sergey Balalaev on 04.12.2023.
//

import SwiftUI
import SUINavigation

struct ModularFirstView: View {

    var string: String

    @State
    private var numberForSecond: Int? = nil

    @State
    private var isBoolShowed: Bool = false

    @Environment(\.isChange)
    private var isChange

    @Environment(\.presentationMode)
    private var presentationMode

    var body: some View {
        ZStack {
            if isChange.wrappedValue {
                Color.gray.ignoresSafeArea()
            } else {
                Color.pink.ignoresSafeArea()
            }
            VStack {
                Text("This is First")
                Text("with: \(string)")
                Button("to Bool") {
                    isBoolShowed = true
                }
                Button("to Second with 22") {
                    numberForSecond = 22
                }
                Button("dismiss") {
                    presentationMode.wrappedValue.dismiss()
                }
                if isChange.wrappedValue {
                    Text("This screen is changed")
                } else {
                    Text("Waitting changes")
                }
            }
        }
        .padding()
        .navigation(isActive: $isBoolShowed){
            Destination.bool
        }
        .navigationAction(item: $numberForSecond, id: Destination.second, paramName: "secondNumber", isRemovingParam: true) { numberValue in
            Destination.second(numberValue, $numberForSecond)
        }
    }
}

#Preview {
    ModularFirstView(string: "test string")
}

#if DEBUG

extension ModularFirstView {

    init(string: String, numberForSecond: State<Int?>) {
        self.string = string
        _numberForSecond = numberForSecond
    }

    init(string: String, isBoolShowed: State<Bool>) {
        self.string = string
        _isBoolShowed = isBoolShowed
    }
}

#endif
