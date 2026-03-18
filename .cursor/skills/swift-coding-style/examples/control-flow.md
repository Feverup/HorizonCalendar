```swift
// GOOD
for _ in 0..<3 {
  print("Hello three times")
}

for (index, person) in attendeeList.enumerated() {
  print("\(person) is at position #\(index)")
}

for index in stride(from: 0, to: items.count, by: 2) {
  print(index)
}

for index in (0...3).reversed() {
  print(index)
}

// BAD
var i = 0
while i < 3 {
  print("Hello three times")
  i += 1
}

var j = 0
while j < attendeeList.count {
  let person = attendeeList[j]
  print("\(person) is at position #\(j)")
  j += 1
}
```
