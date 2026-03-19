# GitHub Copilot PR Review Instructions

When reviewing pull requests for this iOS project, please follow these guidelines:

## 📚 Reference Rules Files

Before reviewing, ensure you're familiar with these project-specific rules that MUST be followed:

**Rules Directory**: `.feverrules/rules/`

Cross-reference the PR against **ALL rules files** in this directory, which include:
- Commit message conventions and format requirements
- Pull request structure and required sections
- Model architecture and state management patterns
- Testing requirements and best practices
- Any other project-specific guidelines

**Review Process**: Check the PR against every rule file in `.feverrules/rules/` to ensure complete compliance with all project standards.

## 🚫 Files to Exclude from Review

**NEVER review the following files:**
- `*.strings` files (e.g., `Localizable.strings`, `InfoPlist.strings`)
  - These are localization files managed by the translation team
  - Changes are automated and should not be reviewed by Copilot

## Code Quality Standards

### Swift Code Style
- Verify that code follows Swift naming conventions (camelCase for variables/functions, PascalCase for types)
- Check for proper use of access control modifiers (`private`, `fileprivate`, `internal`, `public`, `open`)
- Ensure optionals are handled safely (avoid force unwrapping `!` unless absolutely necessary)
- Look for proper error handling using `Result`, `throws`, or completion handlers
- Verify that async/await is used correctly for asynchronous operations
- Check for memory leaks (strong reference cycles, retain cycles in closures)

### Architecture & Patterns
- Verify adherence to the project's architecture (MVVM, Coordinators, etc.)
- Check that models use `@Perceptible` macro (from swift-perception) instead of `@Observable`
- Ensure proper separation of concerns (ViewModels shouldn't contain UI code)
- Look for proper dependency injection patterns
- Verify that networking code is in appropriate repository/service layers

### Testing
- Check if new features have corresponding unit tests
- Verify that tests are meaningful and not just for coverage
- Look for snapshot tests when UI changes are introduced
- Ensure mocks/stubs are used appropriately in tests

### Performance & Best Practices
- Flag inefficient algorithms or unnecessary computations
- Check for proper use of lazy loading and pagination
- Look for potential memory leaks or retain cycles
- Verify that images are properly optimized and cached
- Check for proper handling of background/foreground transitions

### iOS-Specific Concerns
- Verify minimum iOS version compatibility
- Check for proper use of SwiftUI vs UIKit (follow project conventions)
- Look for accessibility issues (missing labels, poor contrast, etc.)
- Verify proper handling of different screen sizes and orientations
- Check for proper use of iOS permissions (location, camera, notifications, etc.)

## PR Structure Review

### Required Sections
Verify that the PR includes:
1. **Context**: Ticket link and clear explanation of the problem and requirements
2. **Changes**: High-level list of what changed
3. **How to Test**: Step-by-step testing instructions with specific devices/configurations
4. **Screenshots/Videos**: Required for any visual changes (check the diff to determine if needed)

### Optional but Recommended Sections
- **Questions**: Open questions or areas needing feedback
- **Trade-offs & Tech Debt**: Document shortcuts, alternative approaches, and known limitations

### PR Title
- Must follow format: `[TICKET-ID] Description`
- Description should be clear and in imperative mood
- Example: `[PLATFORM-7505] Add multi-category event filtering`

## Red Flags to Call Out

### Critical Issues
- Force unwrapping optionals without justification
- Hardcoded credentials or API keys
- Disabled tests without explanation
- Missing error handling in critical paths
- Memory leaks or retain cycles
- Breaking changes without documentation

### Code Smells
- Classes with too many responsibilities
- Duplicated code that should be refactored
- Magic numbers without constants
- Commented-out code without explanation
- TODO comments without ticket references

### PR Issues
- Mixing refactoring with feature changes
- Unrelated changes included
- Missing testing instructions
- No description or context

## Positive Feedback
Also highlight:
- Well-structured code with clear naming
- Comprehensive test coverage
- Good documentation and comments
- Thoughtful error handling
- Performance optimizations
- Accessibility improvements

## Review Tone
- Be constructive and specific in feedback
- Suggest concrete improvements rather than just pointing out problems
- Acknowledge good practices when you see them
- Ask questions when something is unclear rather than assuming intent
- Prioritize feedback (critical vs. nice-to-have)

## Project-Specific Context
- This is a production iOS app (Fever/LiveYourCity)
- Uses Swift Package Manager for dependencies
- Follows modern Swift patterns (async/await, Combine where appropriate)
- Uses swift-perception library for state management
- Has both UIKit and SwiftUI components
- Targets multiple iOS versions (check Base.xcconfig for minimum version)
