```swift
// GOOD - Separate Given/When/Then blocks with a simple line break
func test_getImages_withCityMadridAndUserNotNil_shouldReturnTwoImages() {
    let city = "Madrid"
    let user = User("Pepe")

    let result = sut.getImages(with: city, user: user)

    XCTAssertTrue(result.count == 2)
}

// BAD - Don't add explicit Given/When/Then comments
func test_getImages_withCityMadridAndUserNotNil_shouldReturnTwoImages_bad() {
    // Given
    let city = "Madrid"
    let user = User("Pepe")

    // When
    let result = sut.getImages(with: city, user: user)

    // Then
    XCTAssertTrue(result.count == 2)
}
```
