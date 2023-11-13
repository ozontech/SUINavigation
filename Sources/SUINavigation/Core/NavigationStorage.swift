//
//  NavigationStorage.swift
//
//
//  Created by Sergey Balalaev on 02.12.2022.
//

import SwiftUI

public final class NavigationStorage: ObservableObject {
    final class Item: Identifiable, CustomStringConvertible, Hashable, Equatable {
        var isPresented: Binding<Bool>
        let id: String
        var isSkipped = false
        // This use for duplicated id
        var uid: String?

        var children: [String: NavigateUrlParamsHandler] = [:]
        private(set) var param: NavigationParameter?

        var description: String { "NavigationPathItem with id: \(id) isPresented: \(isPresented.wrappedValue)" }

        init(isPresented: Binding<Bool>, id: String, param: NavigationParameter?) {
            self.isPresented = isPresented
            self.id = id
            self.param = param
        }

        static func == (lhs: Item, rhs: Item) -> Bool {
            lhs.id == rhs.id && lhs.uid == rhs.uid
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(uid)
        }
    }

    @Published
    private(set) var pathItems: [Item] = []

    var rootChildren: [String: NavigateUrlParamsHandler] = [:]

    var actionPath: NavigationActionPath? = nil {
        didSet {
            actionReactor()
        }
    }

    // return uid if has duplicated
    func addItem(isPresented: Binding<Bool>, id: String, param: NavigationParameter?) -> String? {
        let hasTheSameId = pathItems.first(where: { $0.id == id }) != nil
        let item = Item(isPresented: isPresented, id: id, param: param)
        pathItems.append(item)
        print("addItem \(id) pathItems.count = \(pathItems.count)")
        checkSubAction(id: id)
        if hasTheSameId {
            item.uid = UUID().uuidString
            return item.uid
        } else {
            return nil
        }
    }

    func removeItem(isPresented: Binding<Bool>, id: String, uid: String?) {
        guard let foundIndex = pathItems.lastIndex(where: { $0.id == id &&  $0.uid == uid }) else {
            return
        }
        self.pathItems.removeLast(pathItems.count - foundIndex)
        print("removeItem \(id) pathItems.count = \(pathItems.count)")

        // check last skipped
        if pathItems.count > 0 && pathItems.lastIndex(where: { $0.isSkipped == true }) != nil {
            let index: Int? = pathItems.lastIndex { $0.isSkipped == false }
            if let index {
                if index != pathItems.count - 1 {
                    let lastOfItems = pathItems.suffix(from: index + 1)
                    lastOfItems.forEach { pathItem in
                        pathItem.isPresented.wrappedValue = false
                    }
                    pathItems = Array(pathItems[0...index])
                }
            } else {
                popToRoot()
            }
        }
    }

    /// You can use with the Type of View or the NavigationID case
    public func popTo(_ id: NavigationID) {
        guard let foundIndex = pathItems.lastIndex(where: { $0.id == id.stringValue }) else {
            return
        }
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

public struct NavigationViewStorage<Content: View>: View {
    let content: Content

    @StateObject
    var navigationStorage = NavigationStorage()

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        navigation
            .optionalEnvironmentObject(navigationStorage)
    }

    @ViewBuilder
    private var navigation: some View {
        if #available(iOS 16.0, *) {
            // We can't use it from iOS 16 because
            // The NavigationStack have an issue with dismiss many screens
            // In the stack rest artefact empty screen by this case
            // This issue fixed from iOS 17
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
