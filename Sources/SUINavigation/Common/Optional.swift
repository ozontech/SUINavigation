//
//  Optional.swift
//  
//
//  Created by Sergey Balalaev on 28.09.2023.
//

import SwiftUI

public extension Optional where Wrapped: View {
    @inlinable
    static func ?? <V: View>(lhs: Self, rhs: @autoclosure () -> V) -> _ConditionalContent<Self, V> {
        if let wrapped = lhs {
            return ViewBuilder.buildEither(first: wrapped)
        } else {
            return ViewBuilder.buildEither(second: rhs())
        }
    }
}
