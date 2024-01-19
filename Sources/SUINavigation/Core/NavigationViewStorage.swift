//
//  NavigationViewStorage.swift
//  
//
//  Created by Sergey Balalaev on 20.11.2023.
//

import SwiftUI

public struct NavigationViewStorage<Content: View>: View {
    let content: Content

    @OptionalEnvironmentObject
    private var parentNavigationStorage: NavigationStorage?

    @StateObject
    private var navigationStorage: NavigationStorage

    public init(@ViewBuilder content: () -> Content) {
        _navigationStorage = StateObject(wrappedValue: NavigationStorage())
        self.content = content()
    }

    public var body: some View {
        navigation
            .onAppear{
                if let parentNavigationStorage = parentNavigationStorage {
                    parentNavigationStorage.childStorge = navigationStorage
                    navigationStorage.parentStorge = parentNavigationStorage
                }
            }
            .onDisappear(){
                parentNavigationStorage?.childStorge = nil
            }
            .optionalEnvironmentObject(navigationStorage)
    }

    @ViewBuilder
    private var navigation: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                content
            }
        } else {
            NavigationView {
                content
            }
            // bug from Apple: when change screen
            // - dismiss to First View
            // https://developer.apple.com/forums/thread/691242
            .navigationViewStyle(.stack)
        }
    }
}

#if DEBUG
    extension NavigationViewStorage {
        public init(navigationStorage: NavigationStorage, @ViewBuilder content: () -> Content) {
            _navigationStorage = StateObject(wrappedValue: navigationStorage)
            self.content = content()
        }
    }
#endif
