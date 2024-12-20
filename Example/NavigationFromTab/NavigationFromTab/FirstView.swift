//
//  FirstView.swift
//  NavigationFromTab
//
//  Created by Sergey Balalaev on 20.12.2024.
//

import SwiftUI
import SUINavigation

struct FirstView: View {

    @State
    var isSecondShowing = false

    var body: some View {
        VStack {
            Text("First")
            Button {
                isSecondShowing = true
            } label: {
                Text("to Second")
            }
        }
        .padding()
        .navigationTitle("First")
        .navigation(isActive: $isSecondShowing) {
            SecondView()
        }
    }
}
