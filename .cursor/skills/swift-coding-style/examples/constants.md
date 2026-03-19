```swift
// GOOD
enum Math {
  static let e = 2.718281828459045235360287
  static let root2 = 1.41421356237309504880168872
}

let hypotenuse = side * Math.root2

// BAD: Polluting global namespace
let e = 2.718281828459045235360287
let root2 = 1.41421356237309504880168872

let badHypotenuse = side * root2
```
