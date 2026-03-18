```swift
// GOOD
let selector = #selector(viewDidLoad)
view.backgroundColor = .red
let view = UIView(frame: .zero)

// BAD
let badSelector = #selector(ViewController.viewDidLoad)
view.backgroundColor = UIColor.red
let badView = UIView(frame: CGRect.zero)
```
