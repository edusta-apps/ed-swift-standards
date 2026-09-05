# ed-swift-standards — CLAUDE.md

Central Swift lint, format, and probe configs for the EDUsta iOS fleet. Every rule change here reaches every consumer at once on their next resolve.

## Standing decisions

- **Every rule traces to a production reason.** A rule added because "it seemed useful" is exactly what this repo exists to avoid. Motivate every addition.
- **Fix upstream, never patch downstream.** Consumers do not local-override; they open PRs here. If a rule genuinely can't serve a specific consumer, that's a design conversation, not a local disable.
- **This repo is a hosted config, not a Swift package.** No `Package.swift`, no Sources/. Just config files that consumers reference by URL.
- **Versioning:** consumers pin `ref: main` for now (churn tolerated pre-1.0 of the config surface). Once the surface stabilizes, cut tagged releases and consumers pin those instead.

## Before you're done

Any rule change is a breaking-change candidate. Run the probe fixtures (`Lint/probe.sh`) before pushing to confirm no unintended rule regressions.
