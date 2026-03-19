<!-- CURSOR_RULE
description: Convention on how the message of any commit in this project should be formed.
alwaysApply: false
-->

<!-- GITHUB_INSTRUCTION
applyTo: "**"
-->

# Commit Message Guidelines

## Format

```
[<ticket_identifier>] <type>(<scope>): <subject>

<body>

<footer>
```

## Ticket identifier (required)
- The ticket identifier can be extracted from the branch name (e.g., from branch `feature/PLATFORM-7499_add_cursor_commands`, the identifier is `PLATFORM-7499`).

## Type (required)

Must be one of:
- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that don't affect code meaning (formatting, missing semi-colons, etc)
- **refactor**: Code change that neither fixes a bug nor adds a feature
- **perf**: Performance improvement
- **test**: Adding missing tests or correcting existing tests
- **chore**: Changes to build process or auxiliary tools
- **ci**: Changes to CI configuration files and scripts

## Scope (recommended)

The scope should indicate the area of the codebase affected:
- Module name (e.g., `auth`, `profile`, `events`)
- Feature name (e.g., `notifications`, `payments`)
- Component name (e.g., `HomeViewController`, `EventCell`)

## Subject (required)

- Use imperative mood: "add" not "added" or "adds"
- Don't capitalize first letter
- No period (.) at the end
- Limit to 50 characters

## Body (optional)

- Explain the "what" and "why" vs. "how"
- Use imperative mood
- Wrap at 72 characters
- Separate from subject with blank line

## Footer (optional)

- Reference issues: `Fixes #123` or `Closes #456`
- Breaking changes: `BREAKING CHANGE: description`

## Examples

### Simple commit
```
[PLATFORM-3845] fix(auth): resolve token refresh race condition
```

### Detailed commit
```
[DSCVR-1234] feat(events): add event filtering by category

Implement filtering UI with multiple category selection.
Users can now filter events by selecting one or more categories
from a bottom sheet selector.

Closes #234
```

### Breaking change
```
[B2C-5432] refactor(api)!: update event response structure

BREAKING CHANGE: Event API now returns nested venue object
instead of flat venue properties. Update all event consumers
to use event.venue.name instead of event.venueName.
```

## Special Considerations

- **iOS-specific**: Mention Swift version changes, iOS version updates, or framework additions
- **Multiple features**: Consider splitting into separate commits
- **WIP commits**: Use `wip: <description>` for work in progress (these will be squashed later)
- **Dependencies**: Mention if Podfile or Package.swift changed
- **UI changes**: Mention affected screens or components
- **Tests**: Always mention if tests were added or updated

## Forbidden Patterns

❌ Don't use vague messages like:
- "fix bug"
- "update code"
- "changes"
- "wip" (without description)

✅ Do use specific messages like:
- "[PLATFORM-3845] fix(login): prevent crash on invalid email format"
- "[DSCVR-1234] refactor(networking): extract API client to separate module"
- "[B2C-5432] feat(profile): add profile picture upload"
