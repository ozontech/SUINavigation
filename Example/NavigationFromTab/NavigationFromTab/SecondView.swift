//
//  SecondView.swift
//  NavigationFromTab
//
//  Created by Sergey Balalaev on 20.12.2024.
//

import SwiftUI
import SUINavigation

struct SecondView: View {

    @State
    var isLastShowing = false

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Button {
                isLastShowing = true
            } label: {
                Text("to Last")
            }
        }
        .padding()
        .navigationTitle("Second")
        .navigation(isActive: $isLastShowing) {
            LastView()
        }
    }
}
