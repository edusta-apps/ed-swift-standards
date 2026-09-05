# ed-swift-standards

Central Swift lint, format, and probe configs for EDUsta iOS apps and packages under `edusta-apps`. Every `-lib-swift` repo AND every EDUsta iOS app references these via SwiftLint's `parent_config` mechanism.

## What lives here

- `.swiftlint.yml` — canonical SwiftLint config
- `Lint/probe.sh` + fixtures — sanity probe every ED* package runs in CI
- (add others as they land)

## How to consume it

Add to your own `.swiftlint.yml`:

```yaml
parent_config:
  repository: git@github.com:edusta-apps/ed-swift-standards.git
  ref: main
  path: .swiftlint.yml
```

## The rule

**Fix upstream, never patch downstream.** If a rule here is wrong or missing, open a PR here — do not local-override in your own repo's `.swiftlint.yml`. Divergence between shared configs is exactly the drift this repo exists to prevent.
