---
name: pr-review
description: Review the current branch as a pull request, providing comprehensive feedback on code quality, architecture, potential issues, and suggestions for improvement. Use when asked to review code changes, audit a branch before merging, or provide PR-style feedback on uncommitted or committed work.
---

# PR Review

## Overview

Review the current branch as if it were a pull request. Analyze code changes against the base branch and provide structured feedback covering code quality, architecture, potential bugs, performance, security, testing, and iOS-specific concerns.

## Workflow

### 1. Gather Change Information

Run git commands to collect all change information in parallel:

- `git branch --show-current` — get current branch name
- `git remote show origin` — determine base branch (typically `main` or `develop`)
- `git diff <base>...HEAD` — full diff of changes
- `git log <base>..HEAD` — commit history
- `git diff --stat <base>...HEAD` — file statistics
- `git diff --name-status <base>...HEAD` — changed files with status (added, modified, deleted)

### 2. Analyze Changes

Review the changes comprehensively against these criteria:

**Code Quality**
- Readability: Clear variable names, proper formatting, logical structure
- Maintainability: DRY principle, proper abstraction, separation of concerns
- Consistency: Follows project conventions and patterns
- Documentation: Comments for complex logic, updated docs for API changes

**Architecture & Design**
- Design patterns: Appropriate use of patterns (MVVM, Coordinator, etc.)
- SOLID principles: Single responsibility, proper interfaces, dependency injection
- Coupling: Loose coupling between components
- Cohesion: Related functionality grouped together

**Correctness & Safety**
- Logic errors: Potential bugs, edge cases, null safety
- Error handling: Proper error propagation and recovery
- Type safety: Appropriate use of Swift's type system
- Thread safety: Proper handling of concurrency (async/await, actors, etc.)

**Performance**
- Efficiency: Algorithm complexity, unnecessary computations
- Memory: Potential leaks, retain cycles, large allocations
- UI responsiveness: Main thread usage, lazy loading
- Network: Request optimization, caching strategies

**Testing**
- Test coverage: Critical paths covered by tests
- Test quality: Meaningful assertions, edge cases tested
- Test structure: Clear arrange-act-assert pattern
- Testability: Code designed for easy testing

**Security**
- Data protection: Sensitive data handling, encryption
- Input validation: User input sanitization
- API security: Authentication, authorization
- Privacy: Compliance with privacy requirements

### 3. Generate Structured Review

Output the review in the following format:

```markdown
# 🔍 Branch Review: <branch-name>

## 🎯 Overview
<2-3 sentence summary of what this branch accomplishes and overall code quality>

## ⚠️ Issues Found

### 🔴 Critical Issues
<Issues that MUST be addressed before merging>
1. **[File:Line]** Brief description
   - Detailed explanation
   - Suggested fix

### 🟡 Major Issues
<Issues that SHOULD be addressed before merging>
1. **[File:Line]** Brief description
   - Detailed explanation
   - Suggested fix

### 🔵 Minor Issues
<Nice-to-have improvements>
1. **[File:Line]** Brief description
   - Suggestion

## 💡 Suggestions
<General improvements and best practices>
- Consider using X pattern for Y
- Could extract Z into a separate component
- etc.

## ❓ Questions for Author
<Things that need clarification>
1. Why was approach X chosen over approach Y?
2. Should this handle edge case Z?
etc.

## 🧪 Testing Recommendations
<Specific test scenarios to verify>
- [ ] Test scenario 1
- [ ] Test scenario 2
- [ ] Edge case handling
- [ ] Performance with large datasets
- [ ] etc.

## 📝 Documentation
<Documentation feedback>
- Missing documentation for public API X
- README should be updated with Y
- etc.

## 🏁 Verdict
**[APPROVE | REQUEST CHANGES | COMMENT]**

<Final recommendation with reasoning>
```

## iOS-Specific Checklist

When reviewing iOS code, verify:

- Memory management (weak/unowned references where needed)
- Perception-based models use `@Perceptible` (not ObservableObject)
- Views wrap observed properties with `WithPerceptionTracking`
- SwiftUI property wrappers used correctly (@State, @Binding for view-local state)
- No use of Combine/ObservableObject/@Published in new code (use AsyncStream/Task)
- Proper error handling with Result types or throws
- Thread-safe operations with async/await
- Accessibility labels and traits for UI elements
- Support for different device sizes and orientations
- Dark mode support (if applicable)
- Proper use of Swift Package Manager dependencies
- No force unwrapping (!) without clear safety guarantees
- Proper use of Swift's modern concurrency model

## Review Principles

- **Be constructive**: Frame feedback positively and provide actionable suggestions
- **Be specific**: Reference exact file names and line numbers when possible
- **Be thorough**: Don't just look for bugs, consider design, performance, and maintainability
- **Be pragmatic**: Balance perfectionism with practicality
- **Consider context**: Review in the context of the project's existing patterns and conventions
- **Prioritize issues**: Clearly distinguish between critical bugs and minor nitpicks
- **Acknowledge good work**: Call out well-written code and good practices
