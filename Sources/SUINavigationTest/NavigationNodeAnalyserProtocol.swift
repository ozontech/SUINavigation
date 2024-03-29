//
//  NavigationNodeAnalyserProtocol.swift
//
//
//  Created by Sergey Balalaev on 15.01.2024.
//

import SwiftUI
import SUINavigation

public protocol NavigationNodeAnalyserProtocol {
    func searchNodes<V: View>(for rootView: V, isRecursive: Bool) -> NavigationNode
}

extension NavigationCatchMode {
    public func nodeAnalyser(mock: NavigationMockStore? = nil) -> NavigationNodeAnalyserProtocol {
        switch self {
        case .static:
            return NavigationNodeStaticAnalyser(mock: mock)
        case .rendering:
            return NavigationNodeRenderingAnalyser()
        }
    }
}
