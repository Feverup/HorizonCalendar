```swift
class CityRepositoryMock {
    private var getCitiesCallCount = 0
    private var downloadCitiesCallCount = 0

    private var cityItemsStub: [City] = []
    private var downloadCitiesThrowErrorStub = false

    func setDownloadCitiesThrowErrorStub(_ value: Bool) {
        downloadCitiesThrowErrorStub = value
    }

    func setCityItemsStub(_ items: [City]) {
        cityItemsStub = items
    }

    func assertGetCitiesCallCount(callCount: Int, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(getCitiesCallCount, callCount, file: file, line: line)
    }

    func assertDownloadCitiesCallCount(callCount: Int, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(downloadCitiesCallCount, callCount, file: file, line: line)
    }
}

extension CityRepositoryMock: CityRepositoryProtocol {
    func getCities(from country: Country) -> [City] {
        getCitiesCallCount += 1

        return cityItemsStub
    }

    func downloadCities(from country: Country) async throws {
        downloadCitiesCallCount += 1

        if downloadCitiesThrowErrorStub {
            throw NSError.badRequest
        }
    }
}
```
