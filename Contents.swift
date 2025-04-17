import Cocoa

//struct StackIterator<T>: IteratorProtocol {
//    typealias Element = T
//    
//    var stack: Stack<T>
//    
//    mutating func next() -> Element? {
//        return stack.pop()
//    }
//}

struct StackIterator<T>: IteratorProtocol {
    var stack: Stack<T>
    
    mutating func next() -> T? {
        stack.pop()
    }
}

struct Stack<Element>: Sequence {
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
    
    func filter(_ f: (Element) -> Bool) -> Stack<Element> {
        var filteredItems = [Element]()
        
        for item in items where f(item) {
            filteredItems.append(item)
        }
        
        return Stack<Element>(items: filteredItems)
    }
    
    func makeIterator() -> StackIterator<Element> {
        StackIterator(stack: self)
    }
    
    mutating func pushAll<S: Sequence>(_ sequence: S) -> Void where S.Element == Element {
        for item in sequence {
            self.push(item)
        }
    }
}

var intStack = Stack<Int>()
intStack.push(1)
intStack.push(2)
intStack.push(3)
intStack.push(4)
intStack.push(5)
intStack.push(6)

var doubledStack = intStack.map { $0 * 2 }
var filteredStack = intStack.filter { $0 % 2 == 0 }

//print(String(describing: intStack.pop()))
//print(String(describing: intStack.pop()))
//print(String(describing: intStack.pop()))
//
//print(String(describing: doubledStack.pop()))
//print(String(describing: doubledStack.pop()))

print(intStack)
print(filteredStack)

var stringStack = Stack<String>()
stringStack.push("hello")
stringStack.push("world")

//print(String(describing: stringStack.pop()))

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

//print(stringLengths)
//print(stringsUppercased)

func checkIfEqual<T: Equatable>(_ first: T, _ second: T) -> Bool {
    first == second
}

//print(checkIfEqual(1, 1))
//print(checkIfEqual("a string", "a string"))
//print(checkIfEqual("a string", "a different string"))
//print(checkIfEqual(intStack, doubledStack)) // Compile error: Stack does not conform to Equatable

func checkIfDescriptionMatch<T: CustomStringConvertible, U: CustomStringConvertible>(
    _ first: T, _ second: U
) -> Bool {
    first.description == second.description
}

//print(checkIfDescriptionMatch(Int(1), UInt(1)))
//print(checkIfDescriptionMatch(1, 1.0))
//print(checkIfDescriptionMatch(2, 2))
//print(checkIfDescriptionMatch(Float(1.0), Double(1.0)))

var myStack = Stack<Int>()
myStack.push(10)
myStack.push(20)
myStack.push(30)

var myStackIterator = StackIterator(stack: myStack)

while let value = myStackIterator.next() {
    print("got \(value)")
}

//print(myStack)

for value in myStack {
    print("for-in loop: got \(value)")
}

//print(myStack) // Stack<Int>(items: [10, 20, 30])

myStack.pushAll([1, 2, 3])

for value in myStack {
    print("after pushing: got: \(value)")
}

var myOtherStack = Stack<Int>()
myOtherStack.pushAll([1, 2, 3])

myStack.pushAll(myOtherStack)

for value in myStack {
    print("after pushing items onto stack: got \(value)")
}

// Protocols with associated type as type via the use of any keyword

func printElements(from sequence: any Sequence) {
    for item in sequence {
        print(item)
    }
}

let mySequence: any Sequence

// Protocol with associated type as eneric type constraint

func printElements<S: Sequence>(from sequence: S) {
    for element in sequence {
        print(element)
    }
}

let blankSpace = repeatElement("\n", count: 10).joined()

print(blankSpace)

protocol Food {
    var menuListing: String { get }
}

struct Bread: Food {
    var kind = "sourdough"
    var menuListing: String {
        "\(kind) bread"
    }
}

func eat<T: Food>(_ food: T) {
    print("I sure love \(food.menuListing)")
}

// Why not a good old protocol as parameter?
//func eat(_ food: Food) {
//    print("I sure love \(food.menuListing)")
//}

eat(Bread())

//let composedType: [[String:Int]] = []
//let composedType: Array<Dictionary<String,Int>> = []

struct Restaurant {
    private struct SlicedFood<Ingredient: Food>: Food {
        var food: Ingredient
        var menuListing: String {
            "a slice of \(food.menuListing)"
        }
    }
    
    private struct CookedFood<Ingredient: Food>: Food {
        var food: Ingredient
        var menuListing: String {
            "\(food.menuListing), cooked to perfection."
        }
    }
    
//    func makeSlicedBread() -> SlicedFood<Bread> {
//        SlicedFood(food: Bread())
//    }
    
    func makeSlicedBread() -> some Food {
        SlicedFood(food: Bread())
    }
    
//    func makeToast() -> CookedFood<SlicedFood<Bread>> {
//        let slicedBread = SlicedFood(food: Bread())
//        
//        return CookedFood(food: slicedBread)
//    }
    
//    func makeToast() -> SlicedFood<CookedFood<Bread>> {
//        let cookedBread = CookedFood(food: Bread())
//        
//        return SlicedFood(food: cookedBread)
//    }
    
    func makeToast() -> some Food {
        let slicedBread = SlicedFood(food: Bread())
        
        return CookedFood(food: slicedBread)
    }
}

let restaurant = Restaurant()
let toast = restaurant.makeToast()

eat(toast)

func findAll<T: Equatable, C: Collection>(_ collection: C, _ el: T) -> [C.Index] where C.Element == T {
    var ocurrences = [C.Index]()
    
    for idx in collection.indices where collection[idx] == el {
        ocurrences.append(idx)
    }
    
    return ocurrences
}

let foundIntegers = findAll([5, 3, 7, 3, 9], 3)
let foundStrings = findAll(["swift", "c", "python", "ruby", "swift", "c++"], "swift")

print(foundIntegers)
print(foundStrings)
