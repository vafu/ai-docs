# Research Phase

Use this phase before adding dependencies, proposing architecture, replacing hand-rolled logic, or creating infrastructure that might already exist.

## Workspace Research

Inspect the local project first:

```bash
rg "crate_name|feature_name|domain_term" Cargo.toml Cargo.lock .
cargo tree -p crate_name
cargo tree -i dependency_name
```

Look for existing adapters, helper modules, domain types, feature flags, workspace dependency declarations, lockfile entries, and tests. Prefer an existing dependency, crate type, or local abstraction when it fits cleanly.

## External Crate Research

Prefer proven Rust crates for established domains such as serialization, parsing, protocol clients, cryptography, compression, URLs, timestamps, async runtimes, database drivers, CLI, config, logging, telemetry, filesystem behavior, state machines, routing, caching, storage, and watchers.

When choosing a new crate, check primary sources when available: crate documentation, repository README, docs.rs, crates.io metadata, and changelogs or release notes. If network access is unavailable, state what local evidence you used and what still needs confirmation.

Evaluate API fit, maintenance activity, Rust edition/MSRV compatibility, dependency weight, default features, runtime assumptions, license compatibility, and whether external types would leak into this project's public API.

## Output

For research work, report:

- Existing workspace code or dependencies that can be reused.
- Candidate external crates and the tradeoffs that matter.
- Whether custom code is justified.
- The recommended next phase.
