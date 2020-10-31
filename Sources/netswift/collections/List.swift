//
//  ReadOnlyList.swift
//  gsnet
//
//  Created by Gabor Soulavy on 18/11/2015.
//  Copyright © 2015 Gabor Soulavy. All rights reserved.
//

/// List collection class [18 Nov 2015 21:14]

import Foundation

public class List<T:Equatable>: Sequence, Collection {
    public func index(after i: Int) -> Int {
        return items.index(after: i)        
    }
    
    internal var items: [T]

    public var Count: Int {
        get {
            return items.count
        }
    }

    public var Capacity: Int {
        get {
            return items.capacity
        }
    }

    public convenience init() {
        self.init(array: [T]())
    }

    public init(array: [T]) {
        items = array
    }

    public subscript(index: Int) -> T {
        get {
            return items[index]
        }
        set(value) {
            items[index] = value
        }
    }

    public func AsArray() -> [T] {
        return items
    }

    public func AsReadOnly() -> ReadOnlyList<T> {
        return ReadOnlyList(array: self.AsArray())
    }

    public func Add(_ item: T) {
        items.append(item)
    }

    public func AddRange(_ list: List<T>) {
        items.append(contentsOf: list)
    }

    public func Clear() {
        items.removeAll()
    }

    public func Contains(_ item: T) -> Bool {
        return items.contains(item)
    }

    public func Insert(_ index: Int, _ item: T) {
        items.insert(item, at: index)
    }

    public func InsertRange(_ index: Int, _ list: List<T>) {
        items.insert(contentsOf: list, at: index)
    }

    public func Remove(_ item: T) {
        if let i = items.firstIndex(of: item) {
            items.remove(at: i)
        }
    }

    public func RemoveAt(_ index: Int) {
        items.remove(at: index)
    }

    public func Reverse() {
        items.reverse()
    }

    public var startIndex: Int {
        return 0
    }

    public var endIndex: Int {
        return items.count
    }

//    public func generate() -> ListSequenceGenerator<T> {
//        return ListSequenceGenerator(value: items)
//    }
}
