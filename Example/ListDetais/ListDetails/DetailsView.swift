//
//  DetailsView.swift
//  ListDetails
//
//  Created by Sergey Balalaev on 04.12.2024.
//

import SwiftUI

struct DetailsView: View {

    var text: String

    var body: some View {
        Text(text)
        .navigationTitle("Details")
    }
}
