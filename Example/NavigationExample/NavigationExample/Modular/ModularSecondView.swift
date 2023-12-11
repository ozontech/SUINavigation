//
//  ModularSecondView.swift
//  NavigationExample
//
//  Created by Sergey Balalaev on 04.12.2023.
//

import SwiftUI
import SUINavigation

struct ModularSecondView: View {

    var number: Int

    @State
    private var isBoolShowed: Bool = false

    @OptionalEnvironmentObject
    private var navigationStorage: NavigationStorage?

    @Environment(\.isChange)
    private var isChange

    @Environment(\.presentationMode)
    private var presentationMode

    var body: some View {
        VStack {
            Text("This is Second")
            Text("with: \(number)")
            Button("to Bool") {
                isBoolShowed = true
            }
            Button("to Root") {
                navigationStorage?.popToRoot()
            }
            Button("to change") {
                isChange.wrappedValue.toggle()
            }
            Button("dismiss") {
                presentationMode.wrappedValue.dismiss()
            }
            Button("to URL: BoolView/FirstView/SecondView?firstString=??&secondNumber=88") {
                navigationStorage?.append(from: "BoolView/FirstView/SecondView?firstString=??&secondNumber=88")
            }
        }
        .padding()
        .navigationAction(isActive: $isBoolShowed, destinationValue: Destination.bool){ _ in
            isBoolShowed = true
        }
    }
}

#Preview {
    ModularSecondView(number: 777)
}
