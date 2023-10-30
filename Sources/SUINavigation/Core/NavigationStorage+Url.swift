//
//  NavigationStorage+Url.swift
//
//
//  Created by Sergey Balalaev on 10.10.2023.
//

import Foundation

extension NavigationStorage {

    public var currentUrl: String {
        let pathString = pathItems.map { $0.id }.joined(separator: "/")
        let paramsString = pathItems.compactMap {
            guard let param = $0.param else {
                return nil
            }
            return "\(param.name)=\(param.value)"
        }
            .filter{ $0.isEmpty == false }
            .joined(separator: "&")
        if paramsString.isEmpty {
            return pathString
        } else {
            return "\(pathString)?\(paramsString)"
        }
    }

    public func append(from url: String) {
        self.actionPath = NavigationActionPath(url: url)
    }

    public func replace(with url: String) {
        popToRoot()
        Task {
            // wait 0.7 sec (animation of navigation)
            try await Task.sleep(nanoseconds: 7_00_000_000)
            await MainActor.run {
                self.actionPath = NavigationActionPath(url: url)
            }
        }
    }

    func addChild(_ urlComponent: String, _ paramsAction: @escaping NavigateUrlParamsHandler) {
        if let pathItem = pathItems.last {
            pathItem.children[urlComponent] = paramsAction
        } else {
            rootChildren[urlComponent] = paramsAction
        }
    }

    func removeSubAction(id: String) {
        if let actionPath = actionPath {
            if actionPath.popPath(id: id) {
                actionReactor()
            }
        }
    }

    func checkSubAction(id: String) {
        Task {
            // wait 0.7 sec (animation of navigation)
            try await Task.sleep(nanoseconds: 7_00_000_000)
            await MainActor.run {
                removeSubAction(id: id)
            }
        }
    }

    func actionReactor() {
        guard let actionPath = actionPath else {
            return
        }
        guard let actionName = actionPath.path.first else {
            self.actionPath = nil
            return
        }

        let children = pathItems.last?.children ?? rootChildren

        if let action = children[actionName] {
            action(actionPath)
            return
        }
        self.actionPath = nil
    }

}
