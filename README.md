# ed-swift-standards

Central Swift lint, format, and probe configs for EDUsta iOS apps and packages under `edusta-apps`. Every `-lib-swift` repo AND every EDUsta iOS app references these via SwiftLint's `parent_config` mechanism.

Consumers point at this file with `parent_config: https://raw.githubusercontent.com/edusta-apps/ed-swift-standards/main/.swiftlint.yml`. SwiftLint's `parent_config` fails open: if that fetch fails, linting silently falls back to SwiftLint's defaults with only a warning, so a consumer's CI should assert that at least one custom rule from this config actually fires.

CI runs the probe suite on every PR, so a rule change that breaks a fixture cannot merge.

## What lives here

- `.swiftlint.yml` — canonical SwiftLint config
- `Lint/probe.sh` + fixtures — sanity probe every ED* package runs in CI
- (add others as they land)

## Consuming this ruleset

Add to your own `.swiftlint.yml`:

```yaml
parent_config: https://raw.githubusercontent.com/edusta-apps/ed-swift-standards/main/.swiftlint.yml
```

`parent_config` takes a plain URL string — that one-line form is the only
supported one. A `repository:`/`ref:`/`path:` mapping is not a SwiftLint
feature; SwiftLint reads `parent_config` as a plain string, so the mapping
is silently dropped (no error, no rules, exit 0) and the consumer lints
with defaults while looking green.

`parent_config` also fails open on a fetch failure: SwiftLint warns to
stderr, falls back to its defaults, and still exits 0. So a consumer's CI
must run a liveness probe that only a custom rule from this config can
pass:

```sh
probe="$RUNNER_TEMP/RulesetProbe.swift"
printf 'class Probe {}\n' > "$probe"
swiftlint lint --config .swiftlint.yml --reporter json "$probe" | grep -q '"rule_id" *: *"final_class"' || { echo "shared ruleset not live"; exit 1; }
```

On first resolution SwiftLint also writes a `.swiftlint/RemoteConfigCache`
directory next to your config. SwiftLint appends that path to your
`.gitignore` itself the first time it runs, so let it and commit the
result — don't hand-author the entry or check the cache in.

## The rule

**Fix upstream, never patch downstream.** If a rule here is wrong or missing, open a PR here — do not local-override in your own repo's `.swiftlint.yml`. Divergence between shared configs is exactly the drift this repo exists to prevent.
