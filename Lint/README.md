# Lint

`.swiftlint.yml` at the repo root is the **hosted parent config**. Every app
in the org points its own `.swiftlint.yml` at it via `parent_config:` rather
than copying rules into the app repo. When a rule is wrong or missing, fix it
here — never patch around it in an app's local config.

## Using it from an app

Add a `.swiftlint.yml` to the app repo with:

```yaml
parent_config: https://raw.githubusercontent.com/edusta-apps/ed-swift-standards/main/.swiftlint.yml
```

That's the whole file, one key. SwiftLint fetches the parent config over
plain HTTPS (or from its cache) and merges it with anything the app's own
file adds; the app's values win. Replace `main` in the URL with a tag once
this repo cuts releases; track `main` until then. Note that a failed fetch
does not fail the lint: SwiftLint warns and falls back to its defaults, so
CI should assert that a custom rule from this config fires.

App-local additions belong in the same file, below the `parent_config:` key —
for example, an app-specific `excluded:` path. Don't redeclare a rule the
parent already defines; that's a fork, and forks are what this file exists
to prevent.

## What's in the parent config

- Built-in rule thresholds tuned per precedent from a consumer app's
  `.swiftlint.yml` (`file_length`, `type_body_length`, `function_body_length`,
  `nesting`, `identifier_name` exclusions for short semantic names like
  `id`/`sm`/`lg`).
- `custom_rules` implementing every regex-expressible lesson we've collected:
  no `fileprivate`, no `AnyView`, no hydration terminology, no internal
  note-slug comments, no optional/defaulted service dependencies, no `.a11y`
  localization keys, classes are `final`, no new completion-handler APIs,
  `@MainActor` on ViewModels, service protocols are `Sendable`, no inline
  English UI strings, Swift Testing only (no XCTest, no `Task.sleep` in
  tests), no scattered `isLoading`/`hasLoaded` booleans, no raw color/font/
  spacing literals outside a theme module.

## Probe fixtures — `Lint/probes/`

Every custom rule ships with a probe; a rule without a probe fails CI.

`Lint/probes/<rule_id>.swift` is a small fixture containing lines that must
be flagged (marked `// TRUE POSITIVE`) and lines that must not be (marked
`// FALSE POSITIVE CHECK`). `Lint/probes/expected.json` is the exact
`(rule, file, line)` ground truth. `Lint/probe.sh`:

1. Parses every rule id out of `custom_rules:` in `.swiftlint.yml` and fails
   if any of them has no matching `Lint/probes/<rule_id>.swift` fixture.
2. Lints `Lint/probes/` with the real config (temporarily lifting the
   `excluded: [..., Lint/probes/]` entry that keeps these deliberately-bad
   fixtures out of the normal package lint).
3. Diffs the actual violations against `expected.json` exactly — an extra or
   a missing violation is a failure, not just a missing one.

Two rules (`no_xctest`, `no_task_sleep_in_tests`) are scoped with
`included: ".*Tests.*"`, so their fixtures live at
`Lint/probes/Tests/<rule_id>.swift` — the path itself has to satisfy the
rule's scope for the probe to mean anything.

A rule with an `excluded:` scope (e.g. `no_optional_service_dep`,
`no_default_service_instance` excluding `.*Tests.*`; `no_xctest` also
excluding `.*UITests.*`) additionally ships a fixture placed inside the
excluded path, containing the exact pattern that would fire outside it, with
an `expected.json` entry that is an empty array — asserting the rule stays
silent there. An extra violation on that file still fails the diff in step 4.

Run it locally with:

```sh
Lint/probe.sh
```

When you add or change a custom rule, add or update its fixture and
`expected.json` in the same change, then run `Lint/probe.sh` to confirm the
new ground truth actually matches what SwiftLint does before committing it.

## What's deliberately not in here

A few lessons are judgment calls a regex can't safely make, so they're
enforced through human review instead:

- The `EnvironmentKey`-with-a-service-protocol prohibition has four
  documented, approved exceptions (`DependencyContainer.shared` plumbing
  sites). A regex would flag the exceptions too; a human reviews those.
- Strict `// MARK:` section ordering (Properties → Init → Public → Private →
  Helpers → Private Views → Accessibility) isn't mechanically checkable
  beyond the built-in `mark` rule, which only validates formatting of marks
  that already exist.
- A repo-wide `file_header` template isn't enabled yet — no kit-wide header
  convention has been agreed on. Add it here once one is.

## Import order

Imports are layered, not alphabetical: Foundation first, then SwiftUI, then
Combine, then third-party modules, then remaining system frameworks. This is
review-enforced — SwiftLint's `sorted_imports` only knows alphabetical order,
which conflicts with this layering, so that opt-in rule stays off here.
