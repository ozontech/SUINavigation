//
//  NavigationPublished.swift
//
//
//  Created by Sergey Balalaev on 19.02.2024.
//

import Foundation

public protocol NavigationPublishedHandlerProtocol: class {
    associatedtype Value: Any
    var _value: Value { get set }
    var _delay: TimeInterval { get set }
    var _completion: ((Value) -> Void)? { get set}
    var _workItem: DispatchWorkItem? { get set }
}

public protocol NavigationPublishedHandlered: class {
    associatedtype Value: Any
}

public extension NavigationPublishedHandlered where Self: NavigationPublishedHandlerProtocol {
    func catchDidChange(delay: TimeInterval = 0.0, completion: ((Value) -> Void)?) {
        _delay = delay
        _completion = completion
    }

    func clean() {
        _delay = 0.0
        _completion = nil
    }
}

extension NavigationPublishedHandlerProtocol {

    func _toSet(newValue: Value) {
        guard let _completion else {
            return
        }
        if let _workItem {
            _workItem.cancel()
        }
        let workItem = DispatchWorkItem{ [weak self, newValue] in
            guard let self else {
                return
            }
            _completion(self._value)
            self._workItem = nil
        }
        _workItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + _delay, execute: workItem)
    }
}

@propertyWrapper
public class NavigationPublished<Value: Any> {

    final public class Handler: NavigationPublishedHandlerProtocol, NavigationPublishedHandlered {
        public var _value: Value {
            didSet {
                _toSet(newValue: _value)
            }
        }
        public var _delay: TimeInterval = 0
        public var _completion: ((Value) -> Void)? = nil
        public var _workItem: DispatchWorkItem?

        init(_value: Value) {
            self._value = _value
        }
    }

    public var projectedValue: Handler

    public init(wrappedValue: Value) {
        projectedValue = Handler(_value: wrappedValue)
    }

    public var wrappedValue: Value {
        get { projectedValue._value }
        set { projectedValue._value = newValue }
    }
}
