# ed-swift-standards

Central Swift lint, format, and probe configs for EDUsta iOS apps and packages under `edusta-apps`. Every `-lib-swift` repo AND every EDUsta iOS app references these via SwiftLint's `parent_config` mechanism.

Consumers point at this file with `parent_config: https://raw.githubusercontent.com/edusta-apps/ed-swift-standards/main/.swiftlint.yml`. SwiftLint's `parent_config` fails open: if that fetch fails, linting silently falls back to SwiftLint's defaults with only a warning, so a consumer's CI should assert that at least one custom rule from this config actually fires.

## What lives here

- `.swiftlint.yml` — canonical SwiftLint config
- `Lint/probe.sh` + fixtures — sanity probe every ED* package runs in CI
- (add others as they land)

## How to consume it

Add to your own `.swiftlint.yml`:

```yaml
parent_config: https://raw.githubusercontent.com/edusta-apps/ed-swift-standards/main/.swiftlint.yml
```

`parent_config` takes a plain URL string. A `repository:`/`ref:`/`path:` mapping is not a SwiftLint feature; SwiftLint ignores it without any warning and lints with its defaults.

## The rule

**Fix upstream, never patch downstream.** If a rule here is wrong or missing, open a PR here — do not local-override in your own repo's `.swiftlint.yml`. Divergence between shared configs is exactly the drift this repo exists to prevent.
