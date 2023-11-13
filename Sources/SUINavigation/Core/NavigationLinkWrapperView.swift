//
//  NavigationLinkWrapperView.swift
//
//
//  Created by Sergey Balalaev on 23.10.2023.
//

import SwiftUI


struct NavigationLinkWrapperView<Destination: View>: View {
    let isActive: Binding<Bool>
    let destination: Destination?

    @State
    private var uid: String? = nil

    init(isActive: Binding<Bool>, destination: Destination?) {
        self.isActive = isActive
        self.destination = destination
    }

    @ViewBuilder
    var breakView: some View {
        // hacking for supporting iOS 14.5 : https://developer.apple.com/forums/thread/677333
        // better use iOS 16 too with NavigationStack
        if #available(iOS 15.0, *) {
            EmptyView().hidden()
        } else {
            NavigationLink(destination: EmptyView()) {
                EmptyView()
            }.hidden()
        }
    }

    var body: some View {
        breakView
        NavigationLink(
            destination: destination,
            isActive: isActive
        ) {
            EmptyView()
        }
        // bug from Apple: when change screen - dismiss to First View
        // https://developer.apple.com/forums/thread/667460
        .isDetailLink(false)
        .hidden()
        breakView
    }
}
