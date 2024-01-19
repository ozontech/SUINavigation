//
//  NavigationCatch.swift
//  
//
//  Created by Sergey Balalaev on 13.12.2023.
//

import SwiftUI

#if DEBUG

public typealias NavigationCatchHandler = (_ view: any View) -> Void
public typealias NavigationCatchIdHandler = (_ id: String, _ view: any View, _ available: NavigationNodeAvailable) -> Void

public enum NavigationCatchMode {
    case rendering
    case `static`
}

public protocol NavigationCatchMockProtocol {
    func tryGetView<Item: Equatable, Destination: View>(destination: @escaping (Item) -> Destination) -> Destination?
    func tryGetView<Destination: View>(destination: () -> Destination) -> Destination?
}

// Yes it is not goog solution. But needs for hotfix stack overflow when using Environments from `navigation' modifiers.
// It will closed in a future.
public final class NavigationCatch {
    public static let shared = NavigationCatch()

    internal var renderingHandler : NavigationCatchHandler? = nil
    internal var staticHandler : NavigationCatchIdHandler? = nil
    internal var staticMock: NavigationCatchMockProtocol? = nil

    public var catchUrlParamsHandler : ((_ urlComponent: String, _ action: NavigateUrlParamsHandler) -> Void)? = nil

    public func catchView<V: View>(
        to viewType: V.Type,
        mode: NavigationCatchMode = .rendering,
        destination: @escaping (_ view: V) -> Void)
    {
        let handler: NavigationCatchHandler = { view in
            if let view = view as? V {
                destination(view)
            }
        }
        switch mode {
        case .rendering:
            renderingHandler = handler
        case .static:
            staticHandler = {_, view, _ in
                handler(view)
            }
        }
    }

    public func catchAnyView(mode: NavigationCatchMode = .rendering, destination: @escaping (_ view: any View) -> Void) {
        switch mode {
        case .rendering:
            renderingHandler = destination
        case .static:
            staticHandler = {_, view, _ in
                destination(view)
            }
        }
    }

    public func catchIdAnyView(mock: NavigationCatchMockProtocol? = nil, destination: @escaping NavigationCatchIdHandler) {
        staticHandler = destination
        staticMock = mock
    }

    public func clean() {
        renderingHandler = nil
        staticHandler = nil
        staticMock = nil
        catchUrlParamsHandler = nil
    }
}

#endif

internal extension ViewModifier {

    internal func viewDestination<V: View>(_ view: V?) -> V? {
#if DEBUG
        if let view = view, let catchHandler = NavigationCatch.shared.renderingHandler {
            catchHandler(view)
        }
#endif
        return view
    }
}

internal extension View {

    internal func staticCheckDestination<Item: Equatable, Destination: View>(
        item: Binding<Item?>,
        id: String,
        paramName: String? = nil,
        @ViewBuilder destination: @escaping (Item) -> Destination
    ){
#if DEBUG
        guard let catchHandler = NavigationCatch.shared.staticHandler else {
            return
        }
        if let item = item.wrappedValue {
            catchHandler(id, destination(item), .trigger)
        } else if let staticMock = NavigationCatch.shared.staticMock {
            if let view = staticMock.tryGetView(destination: destination) {
                catchHandler(id, view, .mock)
            }
        }
#endif
    }

    internal func staticCheckDestination<Destination: View>(
        isActive: Binding<Bool>,
        id: String,
        @ViewBuilder destination: () -> Destination
    ){
#if DEBUG
        guard let catchHandler = NavigationCatch.shared.staticHandler else {
            return
        }
        if isActive.wrappedValue == true {
            catchHandler(id, destination(), .trigger)
        } else if let staticMock = NavigationCatch.shared.staticMock {
            if let view = staticMock.tryGetView(destination: destination) {
                catchHandler(id, view, .mock)
            }
        }
#endif
    }

    internal func staticCheckUrlParams(
        _ urlComponent: String,
        action: @escaping NavigateUrlParamsHandler
    ){
#if DEBUG
        if let catchUrlParamsHandler = NavigationCatch.shared.catchUrlParamsHandler {
            catchUrlParamsHandler(urlComponent, action)
        }
#endif
    }
}
