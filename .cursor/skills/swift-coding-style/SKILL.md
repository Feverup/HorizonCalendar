---
name: Swift Coding Style
description: Universal Swift coding style — naming, protocols, memory management, optionals, and types. Use when writing or reviewing Swift code.
---

ALWAYS prepend to your messages "following Swift Coding Style skill..."

<skill name="standards">

Universal rules for writing Swift code. These apply to all Swift projects to ensure consistency, clarity, and safety.

<section name="Naming Conventions">
- ALWAYS prioritize clarity over brevity at the call site
- ALWAYS use `camelCase` for variables, properties, and functions
- ALWAYS use `UpperCamelCase` for types and protocols
- ALWAYS begin factory methods with `make`
- ALWAYS name non-mutating verb methods using `-ed` or `-ing` suffixes
- ALWAYS name mutating verb methods using the `formX` pattern
- ALWAYS name capability-based protocols with `-able` or `-ible` suffixes
- ALWAYS use nouns for protocols that describe what something is
- NEVER use class prefixes (e.g., `XXClass`)—rely on module namespacing instead
- ALWAYS make the delegate source the first unnamed parameter in custom delegate methods
</section>

<section name="Type Inference & Context">
- ALWAYS use compiler-inferred context when possible (e.g., `.red`, `.zero`, `#selector(viewDidLoad)`)
- ALWAYS rely on type inference for constants, variables, and small collections
- ONLY specify explicit types when absolutely required (e.g., `CGFloat`, `Int16`)
</section>

<section name="Protocols & Organization">
- NEVER create a protocol for a single struct/class. Use a struct/class with a closure instead
- ALWAYS implement protocol conformances in separate `extension` blocks
- NEVER use `// MARK:` comments
- ALWAYS use `static let` for constants grouped in a caseless `enum` instead of global constants
</section>

<section name="Clean Code & Comments">
- NEVER add comments that state the obvious (e.g. `// Fetch plan` for `repository.fetchPlan()`)
- ALWAYS follow "clean code" guidelines: extract complex logic into private methods with meaningful names instead of adding explanatory comments
</section>

<section name="Access Control">
- ALWAYS group private units (methods, computed vars) in a single `private extension` at the bottom of the file (e.g., `private extension MyViewModel { ... }`)
- NEVER use inline `private func` or `private var` declarations mixed with public ones within the main class/struct body
</section>

<section name="Memory Management">
- ALWAYS extend object lifetime in closures using `[weak self]` and `guard let self else { return }`
- NEVER use `[unowned self]` unless it is absolutely necessary and proven safe
- NEVER use optional chaining (`self?.`) inside closures if you perform multiple operations on `self`
</section>

<section name="Types & Optionals">
- ALWAYS use Swift's native types (e.g., `Double`, `String`) instead of Objective-C bridged types (`NSNumber`, `NSString`)
- ALWAYS use `let` for values that do not change; only use `var` if mutation is required
- ALWAYS use optional chaining (`?`) if an optional value is accessed only once
- ALWAYS use optional binding (`if let`) when unwrapping once to perform multiple operations
- CONSIDER lazy initialization (`lazy var`) for finer-grained control over object lifetime (e.g., `UIViewController` views)
</section>

<section name="Control Flow">
- ALWAYS use the `for-in` loop style (using ranges, `.enumerated()`, `stride()`, or `.reversed()`)
- NEVER use `while-condition-increment` style loops
</section>

<section name="Functions vs Methods">
- ALWAYS prefer methods over free functions to aid readability and discoverability
- ONLY use free functions when they aren't associated with a specific type (e.g., `zip(a, b)`, `max(x, y)`)
</section>

<section name="Imports & Cleanliness">
- ALWAYS use minimal imports (e.g., do not import `UIKit` if `Foundation` suffices)
- NEVER leave unused (dead) code, Xcode template code, or placeholder comments
- ALWAYS document types with business logic (like Interactors) with a top-level comment block explaining their purpose
</section>

</skill>
