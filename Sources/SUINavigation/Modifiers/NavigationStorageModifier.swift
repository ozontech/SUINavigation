//
//  NavigationStorage.swift
//  
//
//  Created by Sergey Balalaev on 28.11.2023.
//

import SwiftUI

struct NavigationStorageModifier: ViewModifier {

    let destination: (_ storage: NavigationStorage) -> Void

    @OptionalEnvironmentObject
    var navigationStorage: NavigationStorage?

    init(destination: @escaping (_ storage: NavigationStorage) -> Void) {
        self.destination = destination
    }

    func body(content: Content) -> some View {
        ZStack{
            content
        }
        .onAppear{
            if let navigationStorage = navigationStorage {
                destination(navigationStorage)
            }
        }
    }
}

public extension View {
    func navigationStorage(
        destination: @escaping (_ storage: NavigationStorage) -> Void
    ) -> some View {
        modifier(NavigationStorageModifier(destination: destination))
    }
}
