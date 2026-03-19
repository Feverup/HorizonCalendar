```swift
// GOOD
struct DataFetcher {
    var fetch: () -> Void
}

extension DataFetcher {
  static let live = DataFetcher(fetch: {
    // fetch data
  })

  static let mock = DataFetcher(fetch: {
    // mock fetch data
  })
}

// BAD: Overusing protocols for a single implementation
protocol DataFetcherProtocol {
    func fetch()
}

final class DataFetcherLive: DataFetcherProtocol {
    func fetch() { }
}

final class DataFetcherMock: DataFetcherProtocol {
    func fetch() { }
}
```
