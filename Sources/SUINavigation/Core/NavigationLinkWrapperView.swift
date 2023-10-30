//
//  NavigationLinkWrapperView.swift
//
//
//  Created by Sergey Balalaev on 23.10.2023.
//

import SwiftUI


struct NavigationLinkWrapperView<Destination: View>: View {
    let destination: Destination?
    let isActive: Binding<Bool>
    let navigationStorage: NavigationStorage?
    let identifier: String
    let param: NavigationParameter?

    @State
    private var uid: String? = nil

    init(id: NavigationID? = nil, destination: Destination?, isActive: Binding<Bool>, param: NavigationParameter? = nil, navigationStorage: NavigationStorage?) {
        self.destination = destination
        self.isActive = isActive
        self.navigationStorage = navigationStorage
        self.identifier = id?.stringValue ?? Destination.navigationID.stringValue
        self.param = param
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
        // bug from Apple: when change screen - dismiss to First View https://developer.apple.com/forums/thread/667460
        .isDetailLink(false)
        .onChange(of: isActive.wrappedValue) { newValue in
            if let navigationStorage = navigationStorage {
                if newValue {
                    uid = navigationStorage.addItem(isPresented: isActive, id: identifier, param: param)
                } else {
                    navigationStorage.removeItem(isPresented: isActive, id: identifier, uid: uid)
                }
            }
        }
        .hidden()
        breakView
    }
}
