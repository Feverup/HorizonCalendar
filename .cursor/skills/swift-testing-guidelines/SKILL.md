---
name: Swift Testing Guidelines
description: Guidelines and conventions for writing unit tests and mocks in Swift. Use when writing or reviewing tests.
---

ALWAYS prepend to your messages "following Swift Testing Guidelines skill..."

<skill name="standards">

Guidelines for writing unit tests, using mocks, and structuring testing code in Swift projects.

<section name="Unit Tests Naming Convention">
- FOR XCTest: ALWAYS name unit test functions following the convention: `test_<testingSubject>_with<conditions>_should<results>`
- FOR Swift Testing: NEVER prefix the test names with `test_` since the `@Test` annotation is already used. Use `<testingSubject>_with<conditions>_should<results>` instead.
</section>

<section name="Unit Tests Structure">
- ALWAYS structure your unit tests into three distinct sections separated by one empty line:
  1. Conditions → **GIVEN**
  2. Actions → **WHEN**
  3. Asserts → **THEN**
- NEVER add explicit `// Given`, `// When`, or `// Then` comments. Rely on the empty lines to separate the sections visually.
</section>

<section name="Swift Testing Framework">
- ALWAYS prioritize using parameterized tests over writing multiple tests with the same code to prevent code duplication when working with the Swift Testing framework.
</section>

<section name="Mocks - Object Mother Pattern">
- ALWAYS use the Object Mother Pattern for creating mock objects
- ALWAYS name the Object Mother using the convention: `<ObjectName>Mother`
- ALWAYS create instance properties within the Object Mother if they are used in more than two different files
- For more information: [Object Mother Pattern Document](https://docs.google.com/presentation/d/1Q6Kdl-2M-bkeDBDBoijdwghLNvubr22hp73BXG3fQlU/edit#slide=id.g138ae4c3cf4_6_0)
</section>

<section name="Mocks - Class Mock">
- ALWAYS name class mocks using the convention: `<DataObject>Mock`
- NEVER use the `Mock` suffix for data objects
</section>

</skill>
