//
//  NavigationStorage+Url.swift
//
//
//  Created by Sergey Balalaev on 10.10.2023.
//

import Foundation

extension NavigationStorage {

    public var currentUrl: String {
        let path = pathItems.map { $0.id }
        let result = NavigationActionPath(path: path)
        var lastChildren = rootChildren
        for pathItem in pathItems {
            if let saveHandler = lastChildren[pathItem.id]?.save {
                saveHandler(result)
            } else if let param = pathItem.param {
                result.pushParam(param)
            }
            lastChildren = pathItem.children
        }
        return result.getURL()
    }

    public func append(from url: String) {
        self.actionPath = NavigationActionPath(url: url)
    }

    public func replace(with url: String) {
        if let parentStorge = self.parentStorge {
            parentStorge.replace(with: url)
            return
        }
        popToRoot()
        Task { @MainActor in
            // wait 0.7 sec (animation of navigation)
            try await Task.sleep(nanoseconds: 7_00_000_000)
            actionPath = NavigationActionPath(url: url)
        }
    }

    func addChild(
        _ urlComponent: String,
        _ paramsAction: @escaping NavigateUrlParamsHandler,
        _ save: NavigateUrlParamsSaveHandler?
    ) -> String {
        let result = Child(load: paramsAction, save: save)
        if let pathItem = pathItems.last {
            pathItem.children[urlComponent] = result
        } else {
            rootChildren[urlComponent] = result
        }
        return result.uid
    }

    func updateChild(
        uid: String,
        _ urlComponent: String,
        _ paramsAction: @escaping NavigateUrlParamsHandler,
        _ save: NavigateUrlParamsSaveHandler?
    ) {
        if let pathItem = pathItems.last, let current = pathItem.children[urlComponent], current.uid == uid {
            pathItem.children[urlComponent] = Child(uid: uid, load: paramsAction, save: save)
            return
        }
        for (index, pathItem) in pathItems.reversed().enumerated() {
            if pathItem.id == urlComponent, index > 0 {
                if let current = pathItems[index - 1].children[urlComponent], current.uid == uid {
                    pathItems[index - 1].children[urlComponent] = Child(uid: uid, load: paramsAction, save: save)
                    return
                }
            }
        }
        if let current = rootChildren[urlComponent], current.uid == uid {
            rootChildren[urlComponent] = Child(uid: uid, load: paramsAction, save: save)
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
        Task { @MainActor in
            // wait 0.7 sec (animation of navigation)
            try await Task.sleep(nanoseconds: 7_00_000_000)
            removeSubAction(id: id)
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

        // If childStorge not nil We founed in anotner navigation storage. We should switch actionPath respond to
        if let childStorage = childStorge {
            self.actionPath = nil
            childStorage.actionPath = actionPath
            return
        }

        let children = pathItems.last?.children ?? rootChildren

        if let action = children[actionName] {
            action.load(actionPath)
            // need check for call custom navigation or remove it from 
            checkSubAction(id: actionName)
            return
        }
        self.actionPath = nil
    }

}
