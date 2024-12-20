//
//  LastView.swift
//  NavigationFromTab
//
//  Created by Sergey Balalaev on 20.12.2024.
//

import SwiftUI
import SUINavigation

struct LastView: View {

    @OptionalEnvironmentObject
    var navigationStorage: NavigationStorage?

    @State
    var isSecondShowing = false

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button {
                navigationStorage?.changeDestination(with: TabNavigation.first)
            } label: {
                Text("to First")
            }
            Button {
                isSecondShowing = true
            } label: {
                Text("to Second")
            }
        }
        .padding()
        .navigationTitle("Last")
        .navigation(isActive: $isSecondShowing) {
            SecondView()
        }
    }
}
