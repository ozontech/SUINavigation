//
//  NavigationViewStorage.swift
//  
//
//  Created by Sergey Balalaev on 20.11.2023.
//

import SwiftUI

/// Synonym for supporting 1.x versions. in 2.x may deprecated.
public typealias NavigationViewStorage = NavigationStorageView

/// Base view of navigation. Analogy for NavigationStack from SwiftUI
public struct NavigationStorageView<Content: View>: View {
    let content: Content

    @OptionalEnvironmentObject
    private var parentNavigationStorage: NavigationStorage?

    @StateObject
    private var navigationStorage: NavigationStorage

    /// - Parameter strategy: used only first way for init `NavigationStorage`.
    /// - Parameter content: root View of navigation.
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
