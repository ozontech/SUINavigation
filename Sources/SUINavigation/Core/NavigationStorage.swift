//
//  NavigationStorage.swift
//
//
//  Created by Sergey Balalaev on 02.12.2022.
//

import SwiftUI

public final class NavigationStorage: ObservableObject {
    public struct Child {
        public internal(set) var uid: String = UUID().uuidString
        public internal(set) var load: NavigateUrlParamsHandler
        public internal(set) var save: NavigateUrlParamsSaveHandler?
    }
    public final class Item: Identifiable, CustomStringConvertible, Hashable, Equatable {
        var isPresented: Binding<Bool>
        public let id: String
        public let viewType: String
        var isSkipped = false
        // This use for duplicated id
        var uid: String?
        // This use for pop, change or replace functions, when use to push other View
        var destinations: [String: NavigationDestinationHandler] = [:]

        @NavigationPublished
        public internal(set) var children: [String: Child] = [:]
        fileprivate(set) var param: NavigationParameter?

        public var description: String { "NavigationPathItem with id: '\(id)' isPresented: \(isPresented.wrappedValue)" }

        init(isPresented: Binding<Bool>, id: String, viewType: String, param: NavigationParameter?) {
            self.isPresented = isPresented
            self.id = id
            self.param = param
            self.viewType = viewType
        }

        public static func == (lhs: Item, rhs: Item) -> Bool {
            lhs.id == rhs.id && lhs.uid == rhs.uid
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(uid)
        }

        func searchDestination<T: Equatable>(for value: T.Type) -> NavigationDestinationHandler? {
            guard let result = destinations[String(describing: T.self)] else {
                return nil
            }
            return result
        }
    }

    // Stack of navigation without root
    @Published
    public private(set) var pathItems: [Item] = []

    // We don't have root from pathItems, so children of this item used by activate some navigation.
    @NavigationPublished
    public internal(set) var rootChildren: [String: Child] = [:]
    // This use for pop, change or replace functions, when use to push other View
    var rootDestinations: [String: NavigationDestinationHandler] = [:]

    // `childStorage` and `parentStorage` need for support nested NavigationStorage.
    public internal(set) weak var childStorage: NavigationStorage? = nil
    weak var parentStorage: NavigationStorage? = nil

    var bindings: [String: NavigationBindingHandler] = [:]

    public private(set) var isNavigationStackUsed: Bool

    // It activate navigation from path
    var actionPath: NavigationActionPath? = nil {
        didSet {
            actionReactor()
        }
    }

    @available(*, deprecated, message: "Using the strategy from init can cause problems with unsynchronised navigation updates. Please change the Navigation Storage Strategy.default value once during a first init.")
    public init(strategy: NavigationStorageStrategy) {
        self.isNavigationStackUsed = NavigationStorageStrategy.isNavigationStackUsed(from: strategy)
    }

    public init() {
        self.isNavigationStackUsed = NavigationStorageStrategy.isNavigationStackUsedDefault
    }

    // To add View Info to Stack at navigation transition. It return id if has duplicates.
    func addItem(isPresented: Binding<Bool>, id: String, viewType: String, param: NavigationParameter?) -> String? {
        let hasTheSameId = pathItems.first(where: { $0.id == id }) != nil
        let item = Item(isPresented: isPresented, id: id, viewType: viewType, param: param)
        pathItems.append(item)
        // This now called from actionReactor, now it don't needs
        //checkSubAction(id: id)
        if hasTheSameId {
            item.uid = UUID().uuidString
            return item.uid
        } else {
            return nil
        }
    }

    // Better update item every time. But it can down performance so it was reserved to future using.
    func updateItem(isPresented: Binding<Bool>, id: String, uid: String?, viewType: String, param: NavigationParameter?) {
        var index: Int? = nil
        if let uid {
            index = pathItems.firstIndex(where: { $0.uid == uid })
        } else {
            index = pathItems.firstIndex(where: { $0.id == id })
        }
        if let index {
            let item = pathItems[index]
            item.isPresented = isPresented
            item.param = param
        }
    }

    // To remove View Info at navigation transition. Uid needs for double id
    func removeItem(isPresented: Binding<Bool>, id: String, uid: String?) {
        guard let foundIndex = pathItems.lastIndex(where: { $0.id == id &&  $0.uid == uid }) else {
            return
        }
        self.pathItems.removeLast(pathItems.count - foundIndex)

        // check last skipped
        if pathItems.count > 0 && pathItems.lastIndex(where: { $0.isSkipped == true }) != nil {
            let index: Int? = pathItems.lastIndex { $0.isSkipped == false }
            if let index {
                if index != pathItems.count - 1 {
                    popTo(index: index)
                }
            } else {
                popToRoot()
            }
        }
    }

    func searchBinding<T: Equatable>(for value: T.Type) -> NavigationBindingHandler {
        guard let result = bindings[String(describing: T.self)] else {
            if let parentStorage = self.parentStorage {
                return parentStorage.searchBinding(for: value)
            } else {
                return {_ in EmptyView()}
            }
        }
        return result
    }

    func registryDestination<T: Equatable>(value: T.Type, id: NavigationID?, handler: @escaping NavigationDestinationHandler) {
        if let lastItem = pathItems.last {
            lastItem.destinations[String(describing: T.self)] = handler
        } else {
            rootDestinations[String(describing: T.self)] = handler
        }
    }

    func searchDestination<T: Equatable>(value: T.Type) -> Int? {
        return pathItems.lastIndex(where: { $0.destinations[String(describing: T.self)] != nil })
    }

    func searchDestination<T: Equatable>(for value: T.Type) -> (handle: NavigationDestinationHandler?, index: Int?) {
        guard let index = searchDestination(value: value) else {
            if let parentStorage = self.parentStorage {
                return parentStorage.searchDestination(for: value)
            } else {
                if let rootDestination = rootDestinations[String(describing: T.self)] {
                    return (rootDestination, nil)
                }
                return (nil, nil)
            }
        }
        return (pathItems[index].destinations[String(describing: T.self)], index)
    }

    /// This function needs for active to push or replace View from .navigationStorageDestination who get `value` from this method.
    /// If you call this from next screen behouver will different: iOS 14-16 pop to  view of this navigation node and push new View, iOS 17-18 replace view of this navigation node and didn't pop to this.
    /// For stable behauver please use `replaceDestination` func.
    @discardableResult
    public func changeDestination<T: Equatable>(with value: T) -> Bool {
        if let handle = searchDestination(for: T.self).handle {
            return handle(value)
        }
        return false
    }

    public func popTo<T: Equatable>(destination value: T.Type) -> Bool {
        let result = searchDestination(for: value)
        if result.handle != nil {
            if let index = result.index {
                popTo(index: index)
            } else {
                popToRoot()
            }
            return true
        }
        return false
    }

    /// This function needs for replace View from .navigationStorageDestination who get `value` from this method.
    /// Analogy with `changeDestination` func but has stable behauver:
    /// If you call this from next screen you always to  pop to view of this navigation node, without depends on iOS 15-18.
    @discardableResult
    public func replaceDestination<T: Equatable>(with value: T) -> Bool {
        let result = searchDestination(for: T.self)
        if let handle = result.handle {
            if let index = result.index {
                popTo(index: index)
            } else {
                popToRoot()
            }
            Task {
                if #available(iOS 18.0, *) {
                    // Delay not needed
                } else if #available(iOS 15.0, *) {
                    // Delay the task by 0.75 second:
                    try await Task.sleep(nanoseconds: 75_0_000_000)
                }
                Task { @MainActor in
                    return handle(value)
                }
            }
        }
        return false
    }

    private func popTo(index foundIndex: Int) {
        // with NavigationStack need support iOS 16
        if #available(iOS 15.0, *) {
            // Work better that original aproach but in iOS 14 not stable
            let lastOfItems = pathItems.suffix(from: foundIndex + 1)
            lastOfItems.forEach { pathItem in
                pathItem.isPresented.wrappedValue = false
            }
        } else {
            NavigationUtils.popTo(index: foundIndex + 1)
        }
        pathItems = Array(pathItems[0...foundIndex])
    }

    /// You can use with the Type of View or the NavigationID case
    public func popTo(_ id: NavigationID) {
        guard let foundIndex = pathItems.lastIndex(where: { $0.id == id.stringValue }) else {
            return
        }
        popTo(index: foundIndex)
    }

    public func popToRoot() {
        if #available(iOS 15.0, *) {
            pathItems.forEach { pathItem in
                pathItem.isPresented.wrappedValue = false
            }
            pathItems = []
        } else {
            // becase we have troubles with iOS 14.5 when stack is big
            NavigationUtils.popToRootView()
            pathItems = []
        }
    }

    public func pop() {
        guard pathItems.count > 0 else {
            return
        }
        // with NavigationStack need support iOS 16
        if #available(iOS 15.0, *) {
            // Work better that original aproach but in iOS 14 not stable
            pathItems.last?.isPresented.wrappedValue = false
        } else {
            NavigationUtils.popTo(index: pathItems.count - 1)
        }
        pathItems = pathItems.dropLast()
    }

    /// see skip(_ type)
    public func popTo<ViewType: View>(_ type: ViewType.Type) {
        popTo(type.navigationID)
    }

    /// see skip(_ type)
    public func skip(_ id: NavigationID) {
        guard let foundItem = pathItems.last(where: { $0.id == id.stringValue }) else {
            return
        }
        foundItem.isSkipped = true
    }

    /// If you want to skip previous screen when you back you can call this func with skipped screen from current screen (for example from onAppear)
    /// Example: We have navigation stack: RoteView->FirstView->SecondView. And I want open NewView, and after close that we need get back to RootView
    /// In NewView you need call:
    /// var body: some View {
    ///     ...
    ///     .onApper {
    ///         navigationStorage.skip(FirstView.self)
    ///         navigationStorage.skip(SecondView.self)
    ///     }
    /// }
    ///  and navigation will be automatically
    public func skip<ViewType: View>(_ type: ViewType.Type) {
        skip(type.navigationID)
    }
}

