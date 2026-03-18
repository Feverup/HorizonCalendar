```swift
enum CityMother {
    static func build(
        name: String = "Madrid",
        country: String = "Spain",
        language: String = "ES"
    ) -> City {
        City(
            name: name,
            country: country,
            language: language
        )
    }

    static var alicante: City {
        build(
            name: "Alicante"
        )
    }

    static var newYork: City {
        build(
            name: "New York",
            country: "USA",
            language: "EN"
        )
    }
}
```
