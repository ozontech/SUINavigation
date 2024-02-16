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

    // Don't use this approach, just for testing
    @Binding
    var numberFromParent: Int?

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
            HStack{
                Text("This is Second")
                if isChange.wrappedValue {
                    Text("changed")
                } else {
                    Text("wait change")
                }
            }
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
            Button("trigger to nil") {
                numberFromParent = nil
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
    SecondView(number: 777, numberFromParent: .constant(0))
}
