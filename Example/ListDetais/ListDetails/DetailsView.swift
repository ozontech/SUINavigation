//
//  DetailsView.swift
//  ListDetails
//
//  Created by Sergey Balalaev on 04.12.2024.
//

import SwiftUI
import SUINavigation

struct DetailsView: View {

    var text: String

    @State
    var isNext = false

    var body: some View {
        VStack {
            Text(text)
            Button {
                isNext = true
            } label: {
                Text("to Next")
            }
        }
        .navigationTitle("Details")
        .navigation(isActive: $isNext) {
            ListView()
        }
    }
}

struct NextView: View {

    var body: some View {
        Text("Next")
        .navigationTitle("Next")
    }
}
