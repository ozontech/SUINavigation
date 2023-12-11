//
//  IdentifiableView.swift
//
//
//  Created by Sergey Balalaev on 07.12.2023.
//

import SwiftUI

struct IdentifiableView: Identifiable, Equatable {
    let id = UUID()
    let view: AnyView

    init(view: any View) {
        self.view = AnyView(view)
    }

    static func == (lhs: IdentifiableView, rhs: IdentifiableView) -> Bool {
        lhs.id == rhs.id
    }
}
