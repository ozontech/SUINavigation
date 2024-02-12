//
//  SomeView.swift
//  MVVM+Router
//
//  Created by Sergey Balalaev on 07.02.2024.
//

import SwiftUI
import SUINavigation

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
            navigationStorage?.popTo("first")
        }
        Button("Go to SecondView") {
            secondValue = 10
            presentationMode.wrappedValue.dismiss()
        }
        Button("Go to Root") {
            navigationStorage?.popToRoot()
        }
        Button("Skip First") {
            navigationStorage?.skip("first")
        }
        Button("Skip Second") {
            navigationStorage?.skip("second")
        }
    }
}
