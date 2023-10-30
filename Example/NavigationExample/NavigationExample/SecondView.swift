//
//  SecondView.swift
//  NavigationExample
//
//  Created by Sergey Balalaev on 28.09.2023.
//

import SwiftUI
import SUINavigation

struct SecondView: View {

    var number: Int

    @State
    private var isBoolShowed: Bool = false

    @OptionalEnvironmentObject
    var navigationStorage: NavigationStorage?

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
        .navigationAction(isActive: $isBoolShowed){
            BoolView()
        } action: { _ in
            isBoolShowed = true
        }
    }
}

#Preview {
    SecondView(number: 777)
}
