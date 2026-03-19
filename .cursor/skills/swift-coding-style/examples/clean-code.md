```swift
// GOOD: Meaningful methods
class PlanInteractor {
    func execute() {
        validateInput()
        fetchPlan()
    }
}

private extension PlanInteractor {
    func validateInput() {
        // complex validation logic
    }

    func fetchPlan() {
        repository.fetchPlan()
    }
}

// BAD: Meaningless comments
class BadPlanInteractor {
    func execute() {
        // Validate input
        // complex validation logic

        // Fetch plan
        repository.fetchPlan()
    }
}
```
