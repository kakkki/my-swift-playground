import Foundation

public struct GenericsPlayground {
    public static func main() {
        Logger.makeBorder { QueueSample.main() }
        Logger.makeBorder { NonGenericType.main() }
        Logger.makeBorder { GenericTypes.main() }    }
}

struct QueueSample {

    struct Queue<Element> {
        private var elements = [Element]()
        
        mutating func enqueue(_ newElement: Element) {
            elements.append(newElement)
        }
        
        mutating func dequeue() -> Element? {
            guard !elements.isEmpty else { return nil }
            return elements.remove(at: 0)
        }
    }

    public static func main() {
        var intQueue = Queue<Int>()
        intQueue.enqueue(3)
        intQueue.enqueue(5)
        print("dequeue : \(intQueue.dequeue())")
        print("dequeue : \(intQueue.dequeue())")
        print("dequeue : \(intQueue.dequeue())")
        
        var strQueue = Queue<String>()
        strQueue.enqueue("Generics")
        strQueue.enqueue("Generics Types")
        print("dequeue : \(strQueue.dequeue())")
        print("dequeue : \(strQueue.dequeue())")
        print("dequeue : \(strQueue.dequeue())")
    }
}

protocol Container {
    associatedtype ItemType
    
    mutating func append(_ item: ItemType)
    var count: Int { get }
    subscript(i: Int) -> ItemType { get }
}

struct NonGenericType {
    
    // Non-generic Type
    struct IntStack: Container {
        var items = [Int]()
        typealias ItemType = Int
        
        mutating func append(_ item: Int) {
            items.append(item)
        }
        
        var count: Int {
            return items.count
        }
        subscript(i: Int) -> Int {
            return items[i]
        }
    }
    
    static func main() {
        var intStack = IntStack()
        intStack.append(2)
        intStack.append(3)
        intStack.append(4)

        print("intStack.count : \(intStack.count)")
        print("intStack[2] : \(intStack[2])")
    }
}

struct GenericTypes {

    // Generic Types
    struct Queue<Element>: Container {
        private var elements = [Element]()
        
        mutating func append(_ item: Element) {
            elements.append(item)
        }
        
        var count: Int {
            return elements.count
        }
        
        subscript(i: Int) -> Element {
            return elements[i]
        }
    }
    
    static func main() {
        var intQueue = Queue<Int>()
        intQueue.append(3)//[3]
        intQueue.append(5)//[3, 5]
        print("intQueue[1] : \(intQueue[1])")
        print("intQueue.count : \(intQueue.count)")

        var stringQueue = Queue<String>()
        stringQueue.append("Generics")//["Generics"]
        stringQueue.append("Generic Types")//["Generics", "Generic Types"]
        print("stringQueue[0] : \(stringQueue[0])")
        print("stringQueue.count : \(stringQueue.count)")
    }
}
