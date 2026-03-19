## Multi-brand assets and generated APIs

This project supports multiple brands while keeping feature code brand-agnostic and ensuring each brand target ships only the assets it needs.

## Goals

- Swap branding without changing feature call sites.
- Keep brand binaries lean by linking only required brand asset packages.
- Access assets through generated, type-safe APIs instead of raw strings.

## Architecture building blocks

- **`AssetsCommon` (shared assets package)**
  - Holds assets shared across all brands.
  - Exposes a resource bundle consumed by generated common asset APIs.

- **`BrandAssetsAPI` (brand-agnostic integration layer)**
  - Single integration point for branded and common asset access.
  - Defines `BrandAssetsProviding` and runtime `BrandAssets.configure(with:)`.
  - Hosts generated type-safe APIs:
    - `Assets.*` for common assets.
    - `BrandedAssets.*` for runtime-selected branded assets.

- **Brand asset packages (for example `AssetsFever`, `AssetsFifaQatar`, `AssetsLiveYourCity`)**
  - Hold brand-specific runtime catalogs.
  - Implement provider conformance by exposing their resource bundle.
  - Must stay isolated and must not depend on each other.
  - These package names are examples; new brands can introduce additional brand asset packages.

- **`FeverBrand`**
  - Holds current brand identity for non-asset brand logic.

- **Brand main target**
  - Selects brand via build configuration.
  - Imports only the required brand package.
  - Calls `BrandConfiguration.configure()` during startup to configure brand identity, assets, and localization.

## Asset ownership rules

- **Common assets**: keep them in the shared assets package (`AssetsCommon`).
- **Branded runtime assets**: keep them in each corresponding brand assets package.
- **Main-target system assets**: keep them in the app target asset catalogs.

## Main-target only assets

Some assets cannot be loaded from SPM resource bundles because they are consumed by system wiring (`Info.plist`, launch screens, app shortcuts). Keep them in main-target assets.

Required entries per brand catalog:

| Asset Name | Type | Description |
| --- | --- | --- |
| AppIcon | App Icon Set | Release icon |
| AppIconDebug | App Icon Set | Debug/staging icon |
| splashLogo | Image Set | Brand splash logo |
| splashBackgroundColor | Color Set | Splash background color |

## Generated-code workflow

When catalogs change:

1. Add or update assets in the correct catalog.
2. Run `make generate`.
3. Consume generated symbols in production code.
4. Run `make verify` (or scoped test/lint flow if needed).

Do not edit generated files manually (for example the generated `Assets` and `BrandedAssets` sources in `BrandAssetsAPI`).

## Production usage (no raw strings)

Prefer generated APIs:

```swift
import BrandAssetsAPI

let favorite = Assets.icFavoriteFull.image
let navbarLogo = BrandedAssets.brandLogoNavbar.image
```

Avoid:

```swift
UIImage(named: "ic_favorite_full")
UIImage(named: "brand_logo_navbar")
Color("splashBackgroundColor")
```

## Bootstrapping and runtime requirements

- `BrandAssets.configure(with:)` must be called before any `BrandedAssets.*` access.
- App startup path configures this via `BrandConfiguration.configure()`.
- Tests using brand assets should configure a provider in setup (for example `configureFeverBrandAssets()`).
- SwiftUI previews do not run full app initialization; configure brand assets explicitly in preview code.

## Dependency graph

```mermaid
graph TD
  subgraph Shared[Shared, brand-agnostic]
    Features[Feature modules] --> FeverUI[FeverUI]
    Features --> BrandAssetsAPI[BrandAssetsAPI]

    FeverUI --> BrandAssetsAPI
    BrandAssetsAPI --> AssetsCommon[AssetsCommon]

    BrandAssetsAPI --> FeverBrand[FeverBrand]
  end

  subgraph BrandTargetA[Brand target A (example)]
    AppA[Main target] --> BrandAssetsAPI
    AppA --> FeverBrand
    AppA --> AssetsBrandA[Brand assets package]
    AssetsBrandA --> BrandAssetsAPI
  end

  subgraph BrandTargetB[Brand target B (example)]
    AppB[Main target] --> BrandAssetsAPI
    AppB --> FeverBrand
    AppB --> AssetsBrandB[Brand assets package]
    AssetsBrandB --> BrandAssetsAPI
  end

  subgraph BrandTargetN[Additional brand target (example)]
    AppN[Main target] --> BrandAssetsAPI
    AppN --> FeverBrand
    AppN --> AssetsBrandN[Brand assets package]
    AssetsBrandN --> BrandAssetsAPI
  end
```

## Design rules to preserve

- No cross-brand dependencies between brand asset packages.
- One brand package linked per brand target.
- Stable branded asset names across brands.
- Centralized startup configuration for brand identity and assets.
