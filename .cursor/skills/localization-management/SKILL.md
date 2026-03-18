---
name: localization-management
description: Multi-brand localization architecture and generated type-safe access. Use when adding or updating localized strings, wiring brand-specific localization packages, or reviewing PRs that touch translations.
---

# Localization Management

## Overview

Keep feature code brand-agnostic while each brand target ships only its own localized resources. Use generated, type-safe APIs from `LocalizationAPI` instead of raw string-key lookups.

## Workflow

### 1. Classify the string change first

- **Shared string**: same value for all brands; lives in the base localization set.
- **Overridable string**: key exists in base and can be overridden per brand.
- **Brand-exclusive string**: key exists only for some brands; consume through an optional accessor.

### 2. Respect package boundaries

- Feature modules import `LocalizationAPI` only.
- Feature modules must not import brand-specific localization packages.
- Brand localization packages (`LocalizationFever`, `LocalizationLiveYourCity`, `LocalizationFifaQatar`) must stay isolated and must not depend on each other.

### 3. Keep key surface stable across brands

- Override keys must match base keys exactly.
- Keep naming consistent so generated accessors remain valid.

### 4. Regenerate type-safe code

- Run `make generate` when localization resources or key sets change.
- Do not manually edit generated localization APIs (for example `L10n.swift`).

### 5. Consume generated APIs in production code

- Use `L10n.*` for shared and overridable strings.
- Use `L10n.OptionalBrandStrings.*` for brand-exclusive keys.
- Avoid raw key access (`NSLocalizedString("...", ...)`) in feature code.

### 6. Ensure runtime configuration is present

- Startup must call `BrandConfiguration.configure()` so localization resolves through the correct brand bundle.
- If tests or previews depend on brand-specific values, configure `LocalizationBundle` with a concrete brand provider.

### 7. Review translation-related PRs with focused checks

- Verify feature code does not import brand localization packages directly.
- Verify startup wiring still configures `LocalizationBundle.configure(with:)`.
- Verify generated files are not manually hand-edited.
- Verify overrides do not drift from the base key surface.
- Verify brand-exclusive keys use optional-accessor patterns.

## Reference material

- See `references/localization-management.md` for architecture details, package-dependency rules, and PR review guidance.
