//
//  ModularObjectView.swift
//  NavigationExample
//
//  Created by Sergey Balalaev on 15.02.2024.
//

import SwiftUI
import SUINavigation

struct ModularObjectView: View {

    let object: ObjectDTO

    @State
    private var isFirstShowed: Bool = false

    @OptionalEnvironmentObject
    private var navigationStorage: NavigationStorage?

    @Environment(\.isChange)
    private var isChange

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("This is Object")
                    if isChange.wrappedValue {
                        Text("changed")
                    } else {
                        Text("wait change")
                    }
                }
                Button("pop to First") {
                    navigationStorage?.popTo(FirstView.self)
                }
                Button("pop to Bool") {
                    navigationStorage?.popTo(BoolView.self)
                }
                Button("to First") {
                    isFirstShowed = true
                }
                Text(object.description)
                if let navigationStorage = navigationStorage {
                    Text("Path: \(navigationStorage.currentUrl)")
                }
            }
        }.navigationAction(isActive: $isFirstShowed) {
            Destination.first("Object")
        }
    }
}
