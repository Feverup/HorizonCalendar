```swift
// GOOD: Private units grouped at the bottom
class MyViewModel {
    func performAction() {
        doPrivateThing()
    }
}

private extension MyViewModel {
    var privateComputedVar: String { "Secret" }

    func doPrivateThing() {
        print(privateComputedVar)
    }
}

// BAD: Inline private modifiers mixed with public units
class BadViewModel {
    private var privateComputedVar: String { "Secret" }

    func performAction() {
        doPrivateThing()
    }

    private func doPrivateThing() {
        print(privateComputedVar)
    }
}
```
