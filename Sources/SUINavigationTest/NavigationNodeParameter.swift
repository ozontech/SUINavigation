//
//  NavigationNodeParameter.swift
//
//
//  Created by Sergey Balalaev on 10.01.2024.
//

import SUINavigation

extension NavigationNodeParameter {
    
    static func check(
        params: [NavigationNodeParameter],
        referenceParams: [NavigationNodeParameter],
        hasCheckingOrder: Bool = false,
        failureResult: inout String,
        failuresCount: inout Int,
        nodeId: String,
        level: Int? = nil
    ) {
        var levelMessageString = ""
        if let level {
            levelMessageString = " on level \(level)"
        }
        if hasCheckingOrder {
            if checkCount(params: params, referenceParams: referenceParams, failureResult: &failureResult, failuresCount: &failuresCount, nodeId: nodeId, levelMessageString: levelMessageString)
            {
                for index in 0..<params.count {
                    if params[index].name != referenceParams[index].name ||
                        params[index].type != referenceParams[index].type
                    {
                        failuresCount += 1
                        failureResult += "\(failuresCount). The '\(nodeId)' node has different params set by index \(index)\(levelMessageString). Actual has name '\(params[index].name)' of type '\(params[index].type)' expected name '\(referenceParams[index].name)' and type '\(referenceParams[index].type)'.\n"
                    }
                }
            }
        } else {
            checkCount(params: params, referenceParams: referenceParams, failureResult: &failureResult, failuresCount: &failuresCount, nodeId: nodeId, levelMessageString: levelMessageString)
            var referenceParams = referenceParams
            for param in params {
                var index = 0
                var isNotFound = true
                while index < referenceParams.count {
                    // this case can not detect double id's from one node
                    if param.name == referenceParams[index].name &&
                        param.type == referenceParams[index].type
                    {
                        isNotFound = false
                        break
                    } else {
                        index += 1
                    }
                }
                if isNotFound {
                    failuresCount += 1
                    failureResult += "\(failuresCount). The '\(nodeId)' node has different params set \(levelMessageString). Not found param with name '\(param.name)' of type '\(param.type)' From this level we have: \(referenceParams.map{ "(name: \($0.name), type: \($0.type) "}).\n"
                }
            }
        }
    }

    @discardableResult
    private static func checkCount(
        params: [NavigationNodeParameter],
        referenceParams: [NavigationNodeParameter],
        failureResult: inout String,
        failuresCount: inout Int,
        nodeId: String,
        levelMessageString: String
    ) -> Bool
    {
        if params.count != referenceParams.count {
            failuresCount += 1
            failureResult += "\(failuresCount). The '\(nodeId)' node has different params count\(levelMessageString). Actual '\(params.count)' expected '\(referenceParams.count)'.\n"
            return false
        } else {
            return true
        }
    }
}
