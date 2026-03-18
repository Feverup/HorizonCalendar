---
name: assets-management
description: Multi-brand asset architecture and generated type-safe access. Use when adding or updating images/colors, wiring brand-specific assets, or replacing raw-string asset access with generated APIs.
---

# Assets Management

## Overview

Keep feature code brand-agnostic while each brand target ships only its own branded assets. Use generated, type-safe APIs from `BrandAssetsAPI` instead of raw string lookups.

## Workflow

### 1. Classify the asset first

- **Common asset**: shared by all brands, place it in `AssetsCommon`.
- **Branded runtime asset**: can differ per brand, place it in each brand asset package.
- **Main-target system asset**: app icons, splash/launch assets, app shortcuts; keep these in main target assets.

### 2. Add the asset to the correct catalog

- Common assets: add them to the shared assets package (`AssetsCommon`).
- Branded assets: add them to each brand package that should expose the asset (for example `AssetsFever`, `AssetsLiveYourCity`, `AssetsFifaQatar`).
- Main-target (system-referenced) assets: keep them in the app target asset catalogs.

### 3. Keep branded names stable across brands

- Branded catalogs must expose consistent asset names so shared generated APIs remain valid.
- Do not create cross-brand dependencies between asset packages.

### 4. Regenerate type-safe code

- Run `make generate` after any asset/localization catalog change.
- Do not manually edit generated APIs (for example `Assets` and `BrandedAssets` sources).

### 5. Consume generated APIs in production code

- Use `Assets.*` for common assets and `BrandedAssets.*` for brand-dependent ones.
- Replace raw-string lookups (`UIImage(named:)`, `Color("...")`, etc.) with generated APIs.

### 6. Ensure runtime configuration is present

- `BrandAssets.configure(with:)` must run during app startup through `BrandConfiguration.configure()`.
- For tests that touch brand assets or brand-based colors, call `configureFeverBrandAssets()` in setup.
- For SwiftUI previews, configure a concrete brand assets provider explicitly.

## Reference material

- See `references/assets-management.md` for architecture details, examples, and design rules.
