import Cocoa

struct Stack<Element> {
    var items = [Element]()
    
    mutating func push(_ newItem: Element) {
        items.append(newItem)
    }
    
    mutating func pop() -> Element? {
        guard !items.isEmpty else { return nil }
        
        return items.removeLast()
    }
}

var intStack = Stack<Int>()
intStack.push(1)
intStack.push(2)

print(String(describing: intStack.pop()))
print(String(describing: intStack.pop()))
print(String(describing: intStack.pop()))

var stringStack = Stack<String>()
stringStack.push("hello")
stringStack.push("world")

print(String(describing: stringStack.pop()))

func myMap<T, U>(_ items: [T], _ txform: (T) -> (U)) -> [U] {
    var result = [U]()
    
    for item in items {
        result.append(txform(item))
    }
    
    return result
}

let strings = ["one", "two", "three"]
//let stringLengths = myMap(strings) { $0.count  }
let stringLengths = myMap(strings, \.count)

print(stringLengths)
