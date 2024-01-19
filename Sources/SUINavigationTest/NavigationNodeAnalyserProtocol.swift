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
