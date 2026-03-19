```swift
// GOOD: Use parameterized tests for multiple test cases
@Test("Drink names are formatted correctly", arguments: [
    ("Coffee", "Coffee"),
    ("Tea", "Tea"),
    ("Water", "Water")
])
func formatting(input: String, expected: String) {
    let formatted = formatDrinkName(input)
    #expect(formatted == expected)
}

// BAD: Writing multiple identical tests
@Test("Coffee name is formatted correctly")
func formatting_withCoffee_shouldFormatCorrectly() {
    let formatted = formatDrinkName("Coffee")
    #expect(formatted == "Coffee")
}

@Test("Tea name is formatted correctly")
func formatting_withTea_shouldFormatCorrectly() {
    let formatted = formatDrinkName("Tea")
    #expect(formatted == "Tea")
}
```
