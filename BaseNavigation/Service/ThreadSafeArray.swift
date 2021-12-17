//
// Created by Pavel Guzenko on 17.12.2021.
//

import Foundation

// Thread safety array, work synchronize work with data on special queue
protocol ThreadSafeProtocol {
    // Type for generic
    associatedtype T
    // Append new element to array
    func append(newElement: T)
    // Remove element by index from array
    // index: position in array for remove
    func removeAtIndex(index: Int)
    // Return last element if array ont empty
    func last() -> T?
    // Return first element if array ont empty
    func first() -> T?
    // Return length of array
    var count: Int { get }
    // Set get and element by []
    subscript(index: Int) -> T { set get }
}

final class ThreadSafeArray<T>: ThreadSafeProtocol {
    // Base array
    private var array: [T] = []
    // Background queue for work
    private let accessQueue = DispatchQueue(label: "ThreadSafe", qos: .utility, attributes: .concurrent)

    public func append(newElement: T) {
        accessQueue.async {
            self.array.append(newElement)
        }
    }

    public func removeAtIndex(index: Int) {
        accessQueue.async {
            self.array.remove(at: index)
        }
    }

    public var count: Int {
        var count = 0

        accessQueue.sync {
            count = array.count
        }

        return count
    }

    public func first() -> T? {
        var element: T?

        accessQueue.sync {
            if array.isEmpty == false {
                element = array.first
            }
        }

        return element
    }

    public func last() -> T? {
        var element: T?

        accessQueue.sync {
            if array.isEmpty == false {
                element = array.last
            }
        }

        return element
    }

    public subscript(index: Int) -> T {
        set {
            accessQueue.async {
                self.array[index] = newValue
            }
        }
        get {
            var element: T!
            accessQueue.sync {
                element = array[index]
            }
            return element
        }
    }
}
