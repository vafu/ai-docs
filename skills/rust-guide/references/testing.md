# Testing

Let tests follow risk.

## Narrow Changes

For pure functions, parsers, formatters, and validators, add small module-owned tests. Include edge cases that explain the intended contract.

Place those tests in `test.rs` inside the module directory:

```text
src/
  feature/
    mod.rs
    service.rs
    test.rs
```

Wire the test module from `mod.rs` with `#[cfg(test)] mod test;`. Do not place tests inline in production files unless the existing codebase has a strong convention that cannot be changed safely in the current task.

## Integration Behavior

Use integration tests when behavior crosses module boundaries, file formats, command execution, network protocols, async scheduling, or public crate APIs.

## Refactors

For refactors, prefer existing tests plus focused regression tests around behavior that could accidentally change. Do not add brittle tests that freeze incidental structure.

## Verification

Run the smallest command that exercises the changed code first:

```bash
cargo test -p crate_name relevant_test
```

Then broaden when needed:

```bash
cargo test
cargo clippy --all-targets --all-features
cargo fmt --check
```

If a verification command cannot run because of missing tools, network, platform dependencies, or time, report that explicitly.
