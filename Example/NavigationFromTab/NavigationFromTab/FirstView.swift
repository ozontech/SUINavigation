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

    @OptionalEnvironmentObject
    var navigationStorage: NavigationStorage?

    var body: some View {
        VStack {
            Text("First")
            Button {
                navigationStorage?.changeDestination(with: TabNavigation.second)
            } label: {
                Text("to Second")
            }
        }
        .padding()
        .navigationTitle("First")
    }
}
