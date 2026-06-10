---
name: rust-guide
description: Use when working in Rust projects, especially for code changes, reviews, refactors, module boundary decisions, error handling, async/concurrency work, or test planning. Provides pragmatic Rust engineering guidance for agents so changes fit the existing codebase instead of introducing unnecessary abstraction or churn.
---

# Rust Guide

## Operating Mode

Start by reading the code that owns the behavior. Prefer the repository's existing patterns over new architecture, and keep changes scoped to the request. Treat warnings, tests, and public API changes as signals about design quality, not just compilation hurdles.

## Default Workflow

1. Inspect module boundaries, call sites, error types, and tests before editing.
2. Identify the smallest coherent behavioral change.
3. Preserve public APIs unless the request or surrounding design justifies changing them.
4. Add or update tests when behavior, parsing, error handling, concurrency, or public contracts change.
5. Run the narrowest useful verification first, then broader checks when the blast radius is larger.

## Rust Preferences

- Model ownership explicitly; avoid cloning to silence borrow errors unless the data is cheap or the clone clarifies ownership.
- For multi-component systems, prefer separating shared contracts into an `api` crate and implementations into a `core` crate. Consumers that only need types or traits should not need to depend on runtime implementation details.
- Within a crate, organize major features as `<feature>/mod.rs` plus sibling implementation files. Treat `mod.rs` as the crate-local public API for that feature: public traits, public structs, type aliases, and re-exports belong there; implementation details belong in the sibling files.
- Prefer trait-backed designs for functional behavior, even when there is currently only one implementation. This keeps composition and future replacement points explicit.
- Keep each implementation file centered on one primary struct. Multiple trait impls for that struct are fine; multiple unrelated struct implementations in one file are a design smell.
- Keep files reasonably small. A large file should trigger an architecture check before adding more code.
- Keep error handling typed at library boundaries and readable at binary/tool boundaries.
- Use iterators where they clarify data flow; use loops when mutation, early exits, or error paths become easier to read.
- Keep async boundaries deliberate. Do not hold locks across `.await` unless the lock type and critical section are intentionally designed for it.
- Make invalid states hard to represent when doing so reduces real runtime checks without overcomplicating construction.

## Tests

Place module tests in a dedicated `test.rs` inside the module directory instead of embedding tests in production files. Keep production files focused on production code, and let each module own the tests for its public behavior.

## Refactoring Rules

Refactor when it reduces actual maintenance cost in the touched area. Avoid broad cleanup while fixing narrow behavior. If duplication exists, first check whether it is accidental repetition, intentionally local clarity, or caused by missing module boundaries.

For deeper guidance, read only the relevant reference:

- `references/module-boundaries.md` for splitting files, moving helpers, or reducing redundancy.
- `references/error-handling.md` for `Result`, `anyhow`, custom errors, and user-facing diagnostics.
- `references/testing.md` for deciding what tests to add and how broad verification should be.
