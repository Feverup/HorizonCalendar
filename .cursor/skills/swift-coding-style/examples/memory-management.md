```swift
class SomeClass {
    var model: Model?

    func performRequest() {
        // GOOD
        resource.request().onComplete { [weak self] response in
            guard let self else { return }
            let model = self.updateModel(response)
            self.updateUI(model)
        }

        // BAD: Might crash if self is released before response returns
        resource.request().onComplete { [unowned self] response in
            let model = self.updateModel(response)
            self.updateUI(model)
        }

        // BAD: Deallocate could happen between updating the model and updating UI
        resource.request().onComplete { [weak self] response in
            let model = self?.updateModel(response)
            self?.updateUI(model)
        }
    }

    func updateModel(_ response: Response) -> Model { /* ... */ }
    func updateUI(_ model: Model) { /* ... */ }
}
```
