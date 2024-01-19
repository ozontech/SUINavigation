//
//  NavigationNodeTestItem.swift
//
//
//  Created by Sergey Balalaev on 26.12.2023.
//

import SUINavigation

public struct NavigationNodeTestItem : Codable {

    public struct Transition : Codable {
        public fileprivate(set) var id: String
        public fileprivate(set) var viewType: String?
        public fileprivate(set) var available: NavigationNodeAvailable
        public fileprivate(set) var attributes: [NavigationNodeAttribute]
        public fileprivate(set) var params: [NavigationNodeParameter]
    }

    public fileprivate(set) var id: String
    public fileprivate(set) var viewType: String?
    public fileprivate(set) var transitions: [Transition] = []

    public var name: String {
        viewType ?? id
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case viewType
        case transitions
    }

    init(_ node: NavigationNode) {
        id = node.id
        viewType = node.viewType
        transitions = node.children.map {
            // Exclude recursiveLoopDetected from checking
            var attributes = $0.attributes
            attributes.removeAll(where: { $0 == .recursiveLoopDetected })

            return Transition(id: $0.id, viewType: $0.viewType, available: $0.available, attributes: attributes, params: $0.params)
        }
    }
}

extension NavigationNodeTestItem.Transition {

    private func check(
        with reference: NavigationNodeTestItem.Transition,
        hasCheckingOrder: Bool = false,
        failureResult: inout String,
        failuresCount: inout Int)
    {
        if id != reference.id {
            failuresCount += 1
            failureResult += "\(failuresCount). Has different identifiers. Actual '\(id)' expected '\(reference.id)'.\n"
        }
        if viewType != reference.viewType {
            failuresCount += 1
            let viewTypeString = viewType ?? "nil"
            let referenceViewTypeString = reference.viewType ?? "nil"
            failureResult += "\(failuresCount). The '\(id)' transition has different view type. Actual '\(viewTypeString)' expected '\(referenceViewTypeString)'.\n"
        }
        NavigationNodeParameter.check(
            params: params,
            referenceParams: reference.params,
            hasCheckingOrder: hasCheckingOrder,
            failureResult: &failureResult,
            failuresCount: &failuresCount,
            nodeId: id
        )

        if available != reference.available {
            failuresCount += 1
            failureResult += "\(failuresCount). The '\(id)' transition has different available property. Actual '\(available)' expected '\(reference.available)'.\n"
        }

        if attributes != reference.attributes {
            failuresCount += 1
            failureResult += "\(failuresCount). The '\(id)' transition has different attributes property. Actual '\(attributes)' expected '\(reference.attributes)'.\n"
        }
    }

    fileprivate func check(
        with reference: NavigationNodeTestItem.Transition,
        hasCheckingOrder: Bool = false
    ) -> String? {
        var failureResult = ""
        var failuresCount = 0

        check(with: reference, hasCheckingOrder: hasCheckingOrder, failureResult: &failureResult, failuresCount: &failuresCount)

        if failuresCount > 0 {
            return "\(failuresCount) differences from the reference were found:\n" + failureResult
        } else {
            return nil
        }
    }
}

extension NavigationNodeTestItem.Transition: Comparable {
    public static func < (lhs: NavigationNodeTestItem.Transition, rhs: NavigationNodeTestItem.Transition) -> Bool {
        lhs.id < rhs.id
    }

    public static func == (lhs: NavigationNodeTestItem.Transition, rhs: NavigationNodeTestItem.Transition) -> Bool {
        lhs.id == rhs.id && lhs.check(with: rhs) == nil
    }

    public static func > (lhs: NavigationNodeTestItem.Transition, rhs: NavigationNodeTestItem.Transition) -> Bool {
        lhs.id > rhs.id
    }
}

extension NavigationNodeTestItem {

    /// Return a failure meesage if has duplication from `items` items else return `nil`.
    public static func checkDuplication(_ items: [NavigationNodeTestItem]) -> String? {
        var failureResult = ""
        var failuresCount = 0

        checkDuplication(items, failureResult: &failureResult, failuresCount: &failuresCount)

        if failuresCount > 0 {
            return "\(failuresCount) duplication from the items were found:\n" + failureResult
        } else {
            return nil
        }
    }

    private static func checkDuplication(
        _ items: [NavigationNodeTestItem],
        failureResult: inout String,
        failuresCount: inout Int
    ) {
        var items = items
        var index = 0
        while index < items.count {
            let item = items[index]
            var checkIndex = index + 1
            while checkIndex < items.count {
                let checkItem = items[checkIndex]
                if item.id == checkItem.id {
                    failuresCount += 1
                    failureResult += "\(failuresCount). Duplication identifier '\(checkItem.id)': Duplicated item: \(checkItem), original item: \(item).\n"
                    items.remove(at: checkIndex)
                } else {
                    checkIndex += 1
                }
            }
            index += 1
        }
    }

    /// Return a failure meesage if has difference with `reference` items else return `nil`.
    public static func check(
        _ items: [NavigationNodeTestItem],
        with reference: [NavigationNodeTestItem],
        hasDuplicationChecking: Bool = true,
        hasCheckingOrder: Bool = false
    ) -> String? {
        var failureResult = ""
        var failuresCount = 0

        check(items, with: reference, hasDuplicationChecking: hasDuplicationChecking, hasCheckingOrder: hasCheckingOrder, failureResult: &failureResult, failuresCount: &failuresCount)

        if failuresCount > 0 {
            return "\(failuresCount) differences from the reference were found:\n" + failureResult
        } else {
            return nil
        }
    }

    private static func check(
        _ items: [NavigationNodeTestItem],
        with reference: [NavigationNodeTestItem],
        hasDuplicationChecking: Bool = true,
        hasCheckingOrder: Bool = false,
        failureResult: inout String,
        failuresCount: inout Int
    ) -> String? {

        var referenceItems = reference

        for item in items {
            var index = 0
            var resultFailureResult = ""
            var resultFailuresCount = 0
            var resultIndex = 0
            while index < referenceItems.count {
                let referenceItem = referenceItems[index]
                var currentFailureResult = ""
                var currentFailuresCount = 0
                if item.id == referenceItem.id {
                    item.check(with: referenceItem, hasCheckingOrder: hasCheckingOrder, failureResult: &currentFailureResult, failuresCount: &currentFailuresCount)
                    if currentFailuresCount == 0 {
                        break
                    } else {
                        if resultFailuresCount == 0 || currentFailuresCount < resultFailuresCount {
                            resultFailureResult = currentFailureResult
                            resultFailuresCount = currentFailuresCount
                            resultIndex = index
                        }
                    }
                }
                index += 1
            }
            if index == referenceItems.count {
                if resultFailuresCount == 0 {
                    failuresCount += 1
                    failureResult += "\(failuresCount). Found new unregistred node with identifier '\(item.id)'.\nItem: \(item).\n"
                } else {
                    failuresCount += resultFailuresCount
                    failureResult += resultFailureResult
                    referenceItems.remove(at: resultIndex)
                }
            } else {
                referenceItems.remove(at: index)
            }
        }

        for referenceItem in referenceItems {
            failuresCount += 1
            failureResult += "\(failuresCount). Not found node with identifier '\(referenceItem.id)'.\nItem: \(referenceItem).\n"
        }

        if failuresCount > 0 {
            return "\(failuresCount) differences from the reference were found:\n" + failureResult
        } else {
            return nil
        }
    }

    private func check(
        with reference: NavigationNodeTestItem,
        hasCheckingOrder: Bool = false,
        failureResult: inout String,
        failuresCount: inout Int)
    {
        if id != reference.id {
            failuresCount += 1
            failureResult += "\(failuresCount). The view '\(name)' has different identifiers. Actual '\(id)' expected '\(reference.id)'.\n"
        }
        if viewType != reference.viewType {
            failuresCount += 1
            let viewTypeString = viewType ?? "nil"
            let referenceViewTypeString = reference.viewType ?? "nil"
            failureResult += "\(failuresCount). The view '\(name)' has different view type. Actual '\(viewTypeString)' expected '\(referenceViewTypeString)'.\n"
        }

        if transitions.count != reference.transitions.count {
            failuresCount += 1
            failureResult += "\(failuresCount). The view '\(name)' has different transition count. Actual '\(transitions.count)' expected '\(reference.transitions.count)'.\n"
        } else {
            var transitions = transitions
            var referenceTransitions = reference.transitions
            if !hasCheckingOrder {
                transitions = transitions.sorted { $0 < $1 }
                referenceTransitions = referenceTransitions.sorted { $0 < $1 }
            }
            let transitionIds = transitions.map { $0.id }
            let referenceTransitionIds = referenceTransitions.map { $0.id }
            if  transitionIds == referenceTransitionIds {
                // check content
                for index in 0..<transitions.count {
                    if let failure = transitions[index].check(with: referenceTransitions[index]) {
                        failuresCount += 1
                        failureResult += "\(failuresCount).\(failure)"
                    }
                }
            } else {
                failuresCount += 1
                failureResult += "\(failuresCount). The view '\(name)' has different transitions ids. Actual '\(transitionIds)' expected '\(referenceTransitionIds)'.\n"
            }
        }
    }

    fileprivate func check(
        with reference: NavigationNodeTestItem,
        hasCheckingOrder: Bool = false
    ) -> String? {
        var failureResult = ""
        var failuresCount = 0

        check(with: reference, hasCheckingOrder: hasCheckingOrder, failureResult: &failureResult, failuresCount: &failuresCount)

        if failuresCount > 0 {
            return "\(failuresCount) differences from the reference were found:\n" + failureResult
        } else {
            return nil
        }
    }

}

extension NavigationNode {

    @discardableResult
    private func addMerged(to items: inout [NavigationNodeTestItem]) -> Bool {

        if self.isRecursiveLoopDetected {
            return false
        }

        let result = NavigationNodeTestItem(self)

        var needAdd: Bool = true

        for item in items {
            if item.check(with: result) == nil {
                needAdd = false
                break
            }
        }

        if needAdd {
            items.append(result)
            for child in children {
                child.addMerged(to: &items)
            }
        }

        return !needAdd
    }

    public func createMergedTestItems() -> [NavigationNodeTestItem] {
        var result: [NavigationNodeTestItem] = []
        addMerged(to: &result)
        return result
    }
}
