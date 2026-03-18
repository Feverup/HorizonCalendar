<!-- CURSOR_RULE
description: Modern Model guidelines using swift-perception for FeverApp
alwaysApply: false
-->

<!-- GITHUB_INSTRUCTION
applyTo: "FeverApp/Sources/**/*Model.swift"
-->

# Model Guidelines (Perception-based)

This project uses **swift-perception** (not traditional ObservableObject). Follow these patterns:

## Structure
- Use `@Perceptible` macro (NOT `ObservableObject`)
- Use `@MainActor` for thread safety
- Use regular properties (NO `@Published` needed)
- Use `@PerceptionIgnored` for properties that shouldn't trigger updates
- Use dependency injection via initializer
- Manage async tasks with `Task` array

## Naming
- Use descriptive names (e.g., `CitySelectorModel`, `EventDetailModel`)
- Can omit `ViewModel` suffix - just use `Model`
- Use clear property names (e.g., `isLoading`, `result`)

## Modern Pattern (2024)
```swift
@MainActor
@Perceptible
public final class ExampleModel {
    // MARK: - Private
    // Use @PerceptionIgnored for mutable vars you don't want observed
    @PerceptionIgnored
    private var tasks: [Task<Void, Never>] = []

    // MARK: - Internal (observed properties)
    var items: [Item] = []
    var isLoading = false
    var result: Loadable<SearchResult> = .idle

    // MARK: - PerceptionIgnored (not observed)
    // Note: let constants don't need @PerceptionIgnored (redundant)
    private let dataSource: ExampleDataSource
    let delegate: AsyncStream<Event>.Continuation

    init(dataSource: ExampleDataSource, delegate: AsyncStream<Event>.Continuation) {
        self.dataSource = dataSource
        self.delegate = delegate

        // Start observing streams
        tasks.append(Task { await observeData() })
    }

    func onDisappear() {
        tasks.forEach { $0.cancel() }
    }

    private func observeData() async {
        for await value in dataSource.fetchData() {
            guard !Task.isCancelled else { return }
            withAnimation(.spring) {
                self.result = await Loadable { try value.get() }
            }
        }
    }
}
```

## Key Differences from Legacy ObservableObject
❌ **Old (Legacy)**: `ObservableObject`, `@Published`, `Combine`, `AnyCancellable`
✅ **New (Modern)**: `@Perceptible`, regular properties, `AsyncStream`, `Task`

## Best Practices
- Use `AsyncStream` for reactive data flows (not Combine Publishers)
- Manage tasks in array, cancel on `onDisappear()`
- Use `withAnimation` when updating UI-bound state
- Use `guard !Task.isCancelled` in async loops
- Use `@PerceptionIgnored` for dependencies/delegates
- Keep models independent of UIKit/SwiftUI views

## SwiftUI Integration
Views use `WithPerceptionTracking`:
```swift
struct ExampleView: View {
    let model: ExampleModel

    var body: some View {
        WithPerceptionTracking {
            VStack {
                Text("\(model.items.count)")
                Button("Load") { model.loadItems() }
            }
        }
    }
}
```
