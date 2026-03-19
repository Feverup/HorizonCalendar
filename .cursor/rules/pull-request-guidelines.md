<!-- CURSOR_RULE
description: Guidelines for creating comprehensive and well-structured pull requests in this project.
alwaysApply: false
-->

<!-- GITHUB_INSTRUCTION
applyTo: "**"
-->

# Pull Request Guidelines

## Example PR Title Format

Use clear, descriptive titles that follow this convention:

```
[PLATFORM-7505] Add multi-category event filtering
```

Format: `[<TICKET>] <description>`

Where:
- **TICKET**: Jira/ticket identifier
- **description**: Clear summary in imperative mood

## Required Sections

Every pull request must include the following sections based on our PR template:

### 1. ℹ️ Context (Required)
- **First line MUST include**: The ticket identifier and a URL link to it
- Provide a brief description of what this PR does and why it exists
- Explain the business or technical motivation

**Context should be inferred from:**
- The information provided in the ticket description

**Example:**
```
**Ticket**: [PLATFORM-7505](https://feverup.atlassian.net/browse/PLATFORM-7505)

**Problem**: Users can currently only filter events by a single category at a time,
which creates friction in the discovery experience. Analytics shows that 40% of users
switch between categories multiple times per session, indicating they're interested
in exploring multiple event types.

**Requirements**: The ticket specifies the need to enable multi-category selection
in the events feed filter. Users should be able to select and deselect multiple
categories, with the filtered results updating in real-time. The selection state
needs to persist across app sessions to avoid forcing users to reconfigure filters
each time they open the app.

**Business Impact**: This addresses a top 5 user-requested feature based on app store
reviews and in-app feedback. Improved filtering is expected to increase event discovery
and potentially boost conversion rates for multi-category browsers.
```

### 2. 👷 Changes (Required)
- Provide a high-level list of changes in this PR
- Keep it concise but meaningful
- Focus on WHAT changed, not HOW it was implemented
- Use bullet points for clarity

**Example:**
```
* Added multi-category filter UI component
* Integrated filter state with event feed
* Updated event repository to support multiple category filters
* Added unit tests for filtering logic
```

### 3. ❓ Questions (Recommended)
- Document open questions or doubts
- Highlight areas where you'd like specific feedback
- Call out decisions you're uncertain about
- Ask for input on implementation approaches

**Example:**
```
* Should we persist the selected filters across app sessions?
* Is the bottom sheet the right UI pattern, or should we use a full screen?
* Should we limit the number of categories that can be selected simultaneously?
```

### 4. ⚠️ Trade-offs & Tech Debt (Important)
Document conscious decisions made in this PR:
- Shortcuts taken and why
- Alternative approaches considered
- Implications for future maintainability
- Known limitations or temporary solutions
- Technical debt introduced

**Example:**
```
* Using UserDefaults for filter persistence instead of Core Data to ship faster.
  Should be migrated to proper storage in a future PR.
* Filter animation is simplified due to time constraints. Could be improved
  with custom transitions.
* Currently limiting to 5 simultaneous categories. May need adjustment based
  on user feedback.
```

### 5. 🧪 How to Test (Required)

#### 📝 Instructions
Provide specific, step-by-step testing instructions:
1. How to checkout the branch: `git checkout <branch-name>`
2. How to build: `make build` or specific Xcode instructions
3. Test devices/configurations:
   - Specific iPhone models (e.g., iPhone 17 Pro, iOS 26.0, simulator)
   - Real device testing requirements
4. Detailed testing steps:
   - Which screen to navigate to
   - What actions to perform
   - What to verify at each step
   - Edge cases to test

**Example:**
```
1. Checkout this branch: `git checkout feature/PLATFORM-7505_multi_category_filter`
2. Run: `make build` or open the project in Xcode
3. Test on:
   * iPhone 17 Pro (iOS 26.0, simulator)
   * iPhone SE (real device, iOS 18.5)
4. Steps:
   - Open the Events tab
   - Tap the Filter button in the navigation bar
   - Select 2-3 categories from the bottom sheet
   - Verify that events are filtered correctly
   - Clear filters and verify all events show again
   - Test with no network connection (cached results)
```

#### 📱 Screenshots / Videos (Conditional)
**When to include this section:**
- Decide based on the diff between the base branch and the commits in this PR
- REQUIRED if there are any visual changes to the UI
- Use table format with before & after columns for easy comparison
- Include videos for complex interactions or animations
- The PR creator MUST upload all screenshots and videos

**When to OMIT this section:**
- Changes only affect documentation
- Changes only affect CI/CD configuration
- Changes only affect scripts with no visual impact
- Pure backend or data model changes with no UI effects
- Trivial changes with no user-facing visual impact

## iOS-Specific Considerations

### When to Include Extra Information
- **Swift version changes**: Mention Swift version requirements
- **iOS version updates**: Note minimum iOS version changes
- **New dependencies**: Document new packages or frameworks added
- **Breaking changes**: Highlight API changes that affect other code
- **Migration steps**: Document any manual steps needed after merging
- **Accessibility**: Mention VoiceOver or accessibility improvements
- **Performance**: Note performance implications for large datasets
- **Permissions**: Document any new privacy permissions required

### Testing Considerations
- Test on both simulator and real devices when UI changes are involved
- Test on different screen sizes (iPhone SE, standard, Plus/Max, iPad)
- Verify dark mode appearance if UI was modified
- Test with different accessibility settings (larger text, VoiceOver)
- Verify memory management for view controllers and large objects

## Forbidden Patterns

❌ **Don't create PRs that:**
- Have no description or context
- Say "WIP" without explanation of what's pending
- Include unrelated changes or fixes
- Have failing tests or linter errors
- Lack testing instructions
- Mix refactoring with feature changes
- Are too large to review effectively (>1000 lines without justification)

✅ **Do create PRs that:**
- Have clear, complete descriptions
- Focus on one logical change
- Include comprehensive testing steps
- Document trade-offs and decisions
- Pass all CI checks
- Are easy for reviewers to understand
- Include visual proof for UI changes
