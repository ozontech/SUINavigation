//
//  NavigationStorageActionItemView.swift
//
//
//  Created by Sergey Balalaev on 13.11.2023.
//

import SwiftUI

struct NavigationStorageActionItemView<Destination: View>: View {
    let isActive: Binding<Bool>
    let id: NavigationID?
    let param: NavigationParameter?

    @State
    private var uid: String? = nil

    @OptionalEnvironmentObject
    private var navigationStorage: NavigationStorage?

    init(isActive: Binding<Bool>, id: NavigationID?, param: NavigationParameter? = nil) {
        self.isActive = isActive
        self.id = id
        self.param = param
    }

    var body: some View {
        EmptyView()
            .onChange(of: isActive.wrappedValue) { newValue in
                if let navigationStorage = navigationStorage {
                    if newValue {
                        uid = navigationStorage.addItem(isPresented: isActive, id: identifier, param: param)
                    } else {
                        navigationStorage.removeItem(isPresented: isActive, id: identifier, uid: uid)
                    }
                }
            }
    }

    var identifier: String {
        id?.stringValue ?? Destination.navigationID.stringValue
    }

}
