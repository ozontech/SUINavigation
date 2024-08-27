//
//  NavigationStorageStrategy.swift
//
//
//  Created by Sergey Balalaev on 23.07.2024.
//

import Foundation

/// On 16.x NavigationView was deprecated but NavigationStack work unstable from iOS 16 to iOS 17.
/// You need chouse of the strategy: use NavigationView or NavigationStack on 16.x.
/// From iOS 17 will use only NavigationStack.
///
/// Why NavigationStack can used from 17.0 and not 16.x:
///
/// I found bug with trigger Binding from iOS with versions [16.0...16.3] with NavigationStack
/// I found bug with double init StateObject as ViewModel from NavigationState with version [16.4...16.9] with NavigationStack.
/// And contrariwise found bug with pop to root after background App when use TabView on 16.x with NavigationView
/// Just ignore message: NavigationLink presenting a value must appear inside a NavigationContent-based NavigationView. Link will be disabled.
///  if you use useStackFromiOS17_0 strategy.
public enum NavigationStorageStrategy {
    /// NavigationStack will used only from iOS 16.0.
    /// You can reproduce bug from BugUITests.testBugWithDoubleStateObjectInit on iOS 16.x.
    case useStackFromiOS16_0
    /// NavigationStack will used only from iOS 17.0.
    /// You can reproduce bug from BugUITests.testBugWithBackToRootOnTabView on iOS 16.x.
    case useStackFromiOS17_0

    public static var `default`: NavigationStorageStrategy = .useStackFromiOS17_0
}

extension NavigationStorageStrategy {

    internal static func isNavigationStackUsed(from strategy: NavigationStorageStrategy) -> Bool{
        if #available(iOS 17.0, *), strategy == .useStackFromiOS17_0 {
            return true
        } else if #available(iOS 16.0, *), strategy == .useStackFromiOS16_0 {
            return true
        } else {
            return false
        }
    }

    internal static let isNavigationStackUsedDefault: Bool = isNavigationStackUsed(from: .default)

}
