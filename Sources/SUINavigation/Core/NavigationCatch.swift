//
//  NavigationCatch.swift
//  
//
//  Created by Sergey Balalaev on 13.12.2023.
//

import SwiftUI

#if DEBUG

public typealias NavigationCatchHandler = (_ view: any View) -> Void

// Yes it is not goog solution. But needs for hotfix stack overflow when using Environments from `navigation' modifiers.
// It will closed in a future.
public final class NavigationCatch {
    public static let shared = NavigationCatch()

    internal var handler : NavigationCatchHandler? = nil

    public func catchView<V: View>(to viewType: V.Type,
                       destination: @escaping (_ view: V) -> Void)
    {
        handler = { view in
            if let view = view as? V {
                destination(view)
            }
        }
    }
}

#endif

internal extension ViewModifier {

    internal func viewDestination<V: View>(_ view: V?) -> V? {
#if DEBUG
        if let view = view, let catchHandler = NavigationCatch.shared.handler {
            catchHandler(view)
        }
#endif
        return view
    }
}
