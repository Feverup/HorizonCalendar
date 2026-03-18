## Localization architecture quick reference

The localization system uses **one API surface** (`LocalizationAPI`) and swaps the underlying bundle by brand at app startup. Brand differences are resolved by resource packaging, not by feature-level brand switching.

## Core responsibilities

- **`LocalizationAPI`**
  - Owns generated `L10n` accessors and `LocalizationBundle.configure(with:)`.
  - Is the only localization module feature code should import.

- **Brand localization packages (`LocalizationFever`, `LocalizationLiveYourCity`, `LocalizationFifaQatar`)**
  - Ship brand-specific `Localizable.strings` resources.
  - Expose providers conforming to `LocalizationBundleProviding`.
  - Depend on `LocalizationAPI` only; never on other brand packages.

- **`BrandConfiguration`**
  - Configures the active brand and calls `LocalizationBundle.configure(with:)` with the matching provider.

- **`scripts/download_translations.rb`**
  - Materializes brand package resources from the base-plus-overrides model.

## Dependency invariants (must hold)

- Feature modules -> `LocalizationAPI` only.
- `LocalizationAPI` -> no brand package dependencies.
- Brand packages -> `LocalizationAPI` only, no cross-brand dependencies.
- Brand targets -> exactly one brand localization package linked.

## Dependency graph

```mermaid
graph TD
  subgraph Shared[Shared, brand-agnostic]
    Features[Feature modules] --> LocalizationAPI[LocalizationAPI]
    LocalizationAPI --> LocalizationBundle[LocalizationBundle runtime selector]
  end

  subgraph BrandTargetA[Brand target A (example)]
    AppA[Main target] --> LocalizationAPI
    AppA --> BrandLocalizationA[LocalizationBrandA]
    BrandLocalizationA --> LocalizationAPI
  end

  subgraph BrandTargetB[Brand target B (example)]
    AppB[Main target] --> LocalizationAPI
    AppB --> BrandLocalizationB[LocalizationBrandB]
    BrandLocalizationB --> LocalizationAPI
  end
```

## PR review: high-risk diffs

- **`FeverApp/Sources/LocalizationAPI/*`**
  - Check generated files are regenerated, not manually edited.
  - Check new brand-exclusive keys use optional accessors.

- **`Fever/Core/Configuration/BrandConfiguration.swift`**
  - Ensure `LocalizationBundle.configure(with:)` is still wired for each brand path.

- **`FeverApp/Sources/Localization*/Resources/*`**
  - Validate override key names stay aligned with base keys (no drift/renames mismatch).

- **`FeverApp/Package.swift`**
  - Reject dependency direction regressions (feature -> brand package, or cross-brand package deps).

- **`scripts/download_translations.rb`**
  - Validate merge behavior preserves base keys and lets brand overrides win.

## Red flags that should block approval

- Feature code imports a brand localization package directly.
- Startup localization wiring is removed or incomplete for any brand.
- Generated localization API is hand-edited.
- Brand overrides introduce key mismatches vs base key surface.
- Brand-exclusive strings are consumed as non-optional in shared feature flows.
