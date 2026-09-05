#!/usr/bin/env bash
# Lint/probe.sh — validates every custom_rules entry in .swiftlint.yml against
# its probe fixture under Lint/probes/. See Lint/README.md.
#
# What it does:
#   1. Parses every custom rule id out of .swiftlint.yml's `custom_rules:` block.
#   2. Fails if any rule id has no `Lint/probes/<rule_id>.swift` fixture.
#   3. Lints Lint/probes/ with the real config (minus the `excluded:` list, so
#      the probe files — normally excluded from the package lint — are
#      actually scanned) and collects the (rule, file, line) violations.
#   4. Compares that set EXACTLY against Lint/probes/expected.json. Extra or
#      missing violations are both failures.
#
# Exit 0 on a clean match, non-zero (with a diff printed) otherwise.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

CONFIG="$REPO_ROOT/.swiftlint.yml"
PROBES_DIR="$REPO_ROOT/Lint/probes"
EXPECTED_JSON="$PROBES_DIR/expected.json"

if ! command -v swiftlint >/dev/null 2>&1; then
  echo "error: swiftlint not found on PATH" >&2
  exit 1
fi

# --- Step 1: extract custom rule ids (top-level keys under `custom_rules:`) ---
RULE_IDS="$(awk '
  /^custom_rules:/ { incustom=1; next }
  incustom && /^[A-Za-z]/ { incustom=0 }
  incustom && /^  [A-Za-z_][A-Za-z0-9_]*:[[:space:]]*$/ {
    line=$0
    sub(/^  /, "", line)
    sub(/:[[:space:]]*$/, "", line)
    print line
  }
' "$CONFIG" | sort -u)"

if [[ -z "$RULE_IDS" ]]; then
  echo "error: found no custom_rules in $CONFIG — parser likely broken" >&2
  exit 1
fi

# --- Step 2: every rule id must have a probe fixture ---
MISSING_FIXTURES=()
while IFS= read -r rule_id; do
  [[ -z "$rule_id" ]] && continue
  if ! find "$PROBES_DIR" -name "${rule_id}.swift" -print -quit | grep -q .; then
    MISSING_FIXTURES+=("$rule_id")
  fi
done <<< "$RULE_IDS"

if (( ${#MISSING_FIXTURES[@]} > 0 )); then
  echo "FAIL: custom rules with no probe fixture (every custom rule ships with a probe):" >&2
  for rule_id in "${MISSING_FIXTURES[@]}"; do
    echo "  - $rule_id  (expected Lint/probes/${rule_id}.swift)" >&2
  done
  exit 1
fi

# --- Step 3: lint Lint/probes/ with the real config, minus `excluded:` ---
TMP_CONFIG="$(mktemp -t swiftlint-probe-config.XXXXXX.yml)"
TMP_JSON="$(mktemp -t swiftlint-probe-actual.XXXXXX.json)"
trap 'rm -f "$TMP_CONFIG" "$TMP_JSON"' EXIT

# The probes directory is deliberately listed in the real config's
# `excluded:` so the package lint skips it. Strip that block here (replacing
# it with an empty list) so this run actually scans Lint/probes/.
awk '
  /^excluded:/ { print "excluded: []"; skip=1; next }
  skip && (/^[[:space:]]/ || /^[[:space:]]*$/) { next }
  { skip=0; print }
' "$CONFIG" > "$TMP_CONFIG"

set +e
swiftlint lint --no-cache --config "$TMP_CONFIG" --reporter json "$PROBES_DIR" > "$TMP_JSON" 2>/tmp/probe_swiftlint_stderr.$$
SWIFTLINT_EXIT=$?
set -e

if [[ $SWIFTLINT_EXIT -gt 2 ]]; then
  # 0 = no violations, 1/2 = violations found (warning/error — both fine here
  # since we're deliberately linting violation fixtures). >2 = swiftlint itself errored.
  echo "error: swiftlint failed to run (exit $SWIFTLINT_EXIT)" >&2
  cat "/tmp/probe_swiftlint_stderr.$$" >&2
  rm -f "/tmp/probe_swiftlint_stderr.$$"
  exit 1
fi
rm -f "/tmp/probe_swiftlint_stderr.$$"

if [[ ! -f "$EXPECTED_JSON" ]]; then
  echo "error: missing $EXPECTED_JSON" >&2
  exit 1
fi

# --- Step 4: compare actual vs. expected (rule, file, line) sets exactly ---
python3 - "$TMP_JSON" "$EXPECTED_JSON" "$PROBES_DIR" "$RULE_IDS" <<'PYEOF'
import json
import os
import sys

actual_path, expected_path, probes_dir, rule_ids_raw = sys.argv[1:5]
custom_rule_ids = {r for r in rule_ids_raw.splitlines() if r}

with open(actual_path) as f:
    raw_actual = json.load(f)

actual = set()
for v in raw_actual:
    rule_id = v["rule_id"]
    if rule_id not in custom_rule_ids:
        continue  # ignore built-in-rule noise (e.g. identifier_name) picked up incidentally
    rel_file = os.path.relpath(v["file"], probes_dir)
    actual.add((rule_id, rel_file, v["line"]))

with open(expected_path) as f:
    raw_expected = json.load(f)

expected = set()
for rel_file, violations in raw_expected.items():
    for v in violations:
        expected.add((v["rule"], rel_file, v["line"]))

missing = sorted(expected - actual)
extra = sorted(actual - expected)

if not missing and not extra:
    print(f"PASS: {len(expected)} expected violation(s) across {len(raw_expected)} probe file(s) matched exactly.")
    sys.exit(0)

print("FAIL: probe.sh actual vs. expected violation mismatch.")
if missing:
    print(f"\nMissing ({len(missing)}) — expected but not flagged by swiftlint:")
    for rule, rel_file, line in missing:
        print(f"  - {rule}  {rel_file}:{line}")
if extra:
    print(f"\nExtra ({len(extra)}) — flagged by swiftlint but not expected:")
    for rule, rel_file, line in extra:
        print(f"  - {rule}  {rel_file}:{line}")
sys.exit(1)
PYEOF
