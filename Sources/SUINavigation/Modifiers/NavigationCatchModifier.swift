//
//  File.swift
//  
//
//  Created by Sergey Balalaev on 29.11.2023.
//

import SwiftUI

#if DEBUG

private struct ClosureKey: EnvironmentKey {

    static let defaultValue : (_ view: any View) -> Void = {_ in }
}

extension EnvironmentValues {
    var catchView : (_ view: any View) -> Void {
        get { self[ClosureKey.self] }
        set { self[ClosureKey.self] = newValue }
    }
}

struct NavigationCatchModifier<V: View>: ViewModifier {

    let destination: (_ view: V) -> Void

    @OptionalEnvironmentObject
    var navigationStorage: NavigationStorage?

    init(destination: @escaping (_ view: V) -> Void) {
        self.destination = destination
    }

    func body(content: Content) -> some View {
        content
            .environment(\.catchView, { view in
                if let view = view as? V {
                    destination(view)
                }
            })
    }
}

public extension View {
    func navigationCatch<V: View>(
        to viewType: V.Type,
        destination: @escaping (_ view: V) -> Void
    ) -> some View {
        modifier(NavigationCatchModifier(destination: destination))
    }
}

#endif
