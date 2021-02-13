import UIKit

// MARK: - Implementation of Queue

struct Queue<T> {
    private var elements: [T] = []
    
    mutating func push(_ element: T) {
        elements.append(element)
    }
    
    mutating func push(_ elements: T ...) {
        for element in elements {
            self.push(element)
        }
    }
    
    mutating func pop() -> T? {
        guard elements.count > 0 else { return nil }
        return elements.removeFirst()
    }
    
    mutating func pop(count: Int) -> [T] {
        var elements: [T] = []
        
        for _ in 0..<count {
            if let element = self.pop() {
                elements.append(element)
            } else {
                break
            }
        }
        
        return elements
    }
    
    func filtered(by condition: (T) -> Bool) -> [T] {
        var results: [T] = []
        
        for element in elements where condition(element) {
            results.append(element)
        }
        
        return results
    }
    
    mutating func filter(by condition: (T) -> Bool) {
        elements = self.filtered(by: condition)
    }
    
    func sorted(by condition: (T, T) -> Bool) -> [T] {
        var results: [T] = elements
        var wasAction = true
        
        while wasAction {
            wasAction = false
            for i in 0..<(results.count - 1) {
                if condition(results[i], results[i + 1]) == false {
                    (results[i], results[i + 1]) = (results[i + 1], results[i])
                    wasAction = true
                }
            }
        }
        
        return results
    }
    
    mutating func sort(by condition: (T, T) -> Bool) {
        elements = self.sorted(by: condition)
    }
    
    mutating func map(by transform: (T) -> T) {
        for i in 0..<elements.count {
            elements[i] = transform(elements[i])
        }
    }
    
    subscript(index: Int) -> T? {
        guard index >= 0 && index < elements.count else { return nil }
        return elements[index]
    }
}

extension Queue: CustomStringConvertible {
    var description: String {
        return "\(elements)"
    }
}

// MARK: - Tests

var queue = Queue<Int>()
queue.push(55)
queue.push(33, 25, 2, 5, 1, 3, 4)
print(queue)

print("# Deleted elements: \(queue.pop(count: 3))")

let sortedQueue = queue.sorted { $0 > $1 }
print("& Sorted queue: \(sortedQueue)")
queue.sort { $0 > $1 }

let filteredQueue = queue.filtered { $0 % 2 == 0 }
print("% Filtered queue: \(filteredQueue)")
queue.filter { $0 % 2 == 0 }

queue.map { $0 * 7 }
print("* Mapped queue: \(queue)")

print("$ Second element: \(queue[1]!)\n")


var queueForPS5 = Queue<String>()
queueForPS5.push("Ivan", "Gosha", "Grisha", "Pasha", "Galya")
print("Today our guests are \(queueForPS5)")
print("But only one of them will get a new PS5!")
print("Let's get started! Firstly, your name must consist of 5 letters and begin with 'G'")
queueForPS5.filter { $0.count == 5 && $0.first == "G" }
print("Wow, there're so few of you guys: \(queueForPS5)")
print("And now, a person who came earlier is a winner!")
let winner = queueForPS5.pop()
print("This is...\(winner!)!")
