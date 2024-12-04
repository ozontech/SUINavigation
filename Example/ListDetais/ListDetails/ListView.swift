//
//  ListView.swift
//  ListDetails
//
//  Created by Sergey Balalaev on 04.12.2024.
//

import SwiftUI

/// Trigger between TrueListView and FalseListView solution to target
typealias ListView = TrueListView

extension ListView {
    static let elements: [String] = (1...100).map{ index in
        "Element \(index)"
    }
}

/// Incorrect implementation of the list when navigation is focused on each list item
struct FalseListView: View {

    var array = ListView.elements

    @State
    var isDetailsShow = false

    var body: some View {
        List(array, id: \.self) { item in
            Button {
                isDetailsShow = true
            } label: {
                Text(item)
                    .navigation(isActive: $isDetailsShow) {
                        DetailsView(text: item)
                    }
            }
        }
        .padding(0)
        .navigationTitle("Elements")
    }
}

/// Сorrect implementation of the list when navigation is focused on the entire screen and not on its individual elements
struct TrueListView: View {

    var array = ListView.elements

    @State
    var detailsItem: String? = nil

    var body: some View {
        List(array, id: \.self) { item in
            Button {
                detailsItem = item
            } label: {
                Text(item)
            }
        }
        .padding(0)
        .navigationTitle("Elements")
        .navigation(item: $detailsItem) { item in
            DetailsView(text: item)
        }
    }
}
