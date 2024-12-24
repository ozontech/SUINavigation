//
//  ReplaceView.swift
//  NavigationExample
//
//  Created by Sergey Balalaev on 24.12.2024.
//

import SwiftUI
import SUINavigation

enum ReplaceValue: NavigationParameterValue, Equatable {

    init?(_ description: String) {
        self = .replace(description)
    }
    
    static var defaultValue = replace("")

    var stringValue: String {
        switch self {
        case .replace(let value):
            return value
        }
    }

    case replace(_ string: String)
}

struct ReplaceView: View {

    var string: String

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
                Text("This is Replace")
                if isChange.wrappedValue {
                    Text("changed")
                } else {
                    Text("wait change")
                }
            }
            Text("with: \(string)")
            Button("to Bool") {
                isBoolShowed = true
            }
            Button("to Root") {
                navigationStorage?.popToRoot()
            }
            Button("to change") {
                isChange.wrappedValue.toggle()
            }
            HStack {
                Button("dismiss") {
                    presentationMode.wrappedValue.dismiss()
                }
                Button("popBack") {
                    navigationStorage?.pop()
                }
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
