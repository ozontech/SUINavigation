//
//  IsRootNavigationModifier.swift
//
//
//  Created by Sergey Balalaev on 28.09.2023.
//

import SwiftUI

struct IsRootNavigationModifier: ViewModifier {

    @Binding var isRoot: Bool

    @OptionalEnvironmentObject
    var navigationStorage: NavigationStorage?

    func body(content: Content) -> some View {
        content
            .onChange(of: navigationStorage?.pathItems) { value in
                guard isRoot != value?.isEmpty else {
                    return
                }
                isRoot = value?.isEmpty ?? false
            }
    }
}

public extension View {
    func navigationStorage(isRoot: Binding<Bool>) -> some View {
        navigationModifier(IsRootNavigationModifier(isRoot: isRoot))
    }
}
