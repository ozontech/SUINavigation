//
//  NavigationViewStorage.swift
//  
//
//  Created by Sergey Balalaev on 20.11.2023.
//

import SwiftUI

/// Synonym (needs change with NavigationViewStorage in a future)
typealias NavigationStorageView = NavigationViewStorage

public struct NavigationViewStorage<Content: View>: View {
    let content: Content

    @OptionalEnvironmentObject
    private var parentNavigationStorage: NavigationStorage?

    @StateObject
    private var navigationStorage: NavigationStorage

    /// - param strategy used only first way for init NavigationStorage
    /// See NavigationStorageStrategy
    @available(*, deprecated, message: "Using the strategy from init can cause problems with unsynchronised navigation updates. Please change the Navigation Storage Strategy.default value once during a first init.")
    public init(strategy: NavigationStorageStrategy, @ViewBuilder content: () -> Content) {
        _navigationStorage = StateObject(wrappedValue: NavigationStorage(strategy: strategy))
        self.content = content()
    }

    public init(@ViewBuilder content: () -> Content) {
        _navigationStorage = StateObject(wrappedValue: NavigationStorage())
        self.content = content()
    }

    public var body: some View {
        navigation
            .onAppear{
                if let parentNavigationStorage = parentNavigationStorage {
                    parentNavigationStorage.childStorage = navigationStorage
                    navigationStorage.parentStorage = parentNavigationStorage
                }
            }
            .onDisappear(){
                parentNavigationStorage?.childStorage = nil
            }
            .optionalEnvironmentObject(navigationStorage)
    }

    @ViewBuilder
    private var navigation: some View {
        if #available(iOS 16.0, *), navigationStorage.isNavigationStackUsed {
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
