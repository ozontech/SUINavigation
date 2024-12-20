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
        // False! It's can generate warning to console because used by TabView. Please see the FirstView to how to make navigate from the Root view at NavigationStorageView
        .navigation(isActive: $isLastShowing) {
            LastView()
        }
    }
}
