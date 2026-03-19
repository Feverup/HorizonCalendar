<!-- CURSOR_RULE
description: How to verify changes in Fever (always use Makefile)
alwaysApply: true
-->

<!-- GITHUB_INSTRUCTION
applyTo: "**"
-->

# Verification entrypoint (Makefile)

Always verify changes using `make` commands from the repo root. Do not describe manual Xcode steps as the primary workflow.

## Prereqs

If not installed already, run `make setup` from the repo root to install all required development tools (pre-commit, xcsift, node, cupertino) and configure git hooks.

## Required commands

- Format code: `make format`
- Lint code: `make lint`
- Verify (auto-fix format + lint + tests): `make verify`
- Run app on simulator for UI verification: `make run`
- Generate type-safe code for assets and localizations: `make generate`

## Tests

- Run tests directly: `make test`
- Stage changes before testing so pre-commit hooks see your updates.
- Consider focused test runs for changed units using `make test TEST_TARGET="TargetName"` or `make test TEST_TARGET="TargetName" TEST_ONLY="SomeTestClass/testExample"`
- You can also scope `make verify` in the same way, for example:
  - `make verify TEST_TARGET="TargetName" TEST_ONLY="SomeTestClass/testExample"`
- If the simulator destination is missing, override defaults, for example:
  - `make test SIMULATOR_NAME="iPhone 17 Pro" SIMULATOR_OS="26.2"`

## UI Verification (Simulator MCP)

When UI changes are relevant, run the app with `make run` and use the `ios-simulator` MCP server to drive the simulator UI (tap/type/inspect/screenshot) to verify behavior.
