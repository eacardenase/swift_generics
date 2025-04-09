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
    
    func map<U>(_ txform: (Element) -> U) -> Stack<U> {
        var mappedItems = [U]()
        
        for item in items {
            mappedItems.append(txform(item))
        }
        
        return Stack<U>(items: mappedItems)
    }
}

var intStack = Stack<Int>()
intStack.push(1)
intStack.push(2)

var doubledStack = intStack.map { $0 * 2 }

print(String(describing: intStack.pop()))
print(String(describing: intStack.pop()))
print(String(describing: intStack.pop()))

print(String(describing: doubledStack.pop()))
print(String(describing: doubledStack.pop()))

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
let stringsUppercased = myMap(strings, \.localizedUppercase) // only properties are allowed with key-paths

print(stringLengths)
print(stringsUppercased)

func checkIfEqual<T: Equatable>(_ first: T, _ second: T) -> Bool {
    first == second
}

print(checkIfEqual(1, 1))
print(checkIfEqual("a string", "a string"))
print(checkIfEqual("a string", "a different string"))
//print(checkIfEqual(intStack, doubledStack)) // Compile error: Stack does not conform to Equatable
