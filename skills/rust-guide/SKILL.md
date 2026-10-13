---
name: rust-guide
description: "Use when working in Rust projects across the development lifecycle: design, research, architecture, implementation, testing, and refining. Applies to code changes, reviews, refactors, crate/module boundary decisions, dependency research, API design, error handling, async/concurrency work, and test planning. Provides pragmatic Rust engineering guidance so agents fit the existing codebase instead of introducing unnecessary abstraction or churn."
---

# Rust Guide

## Operating Mode

Determine the current phase before acting. If the user asks for a plan, proposal, architecture, review, or implementation, choose the matching phase and read only the relevant reference. Move backward when findings invalidate the current direction; move forward when the phase has enough evidence to proceed.

Always start by reading the code that owns the behavior. Prefer existing project types, crates, modules, and patterns over new architecture. Treat warnings, tests, and public API changes as signals about design quality, not just compilation hurdles.

## Lifecycle

1. **Design**: Clarify the goal, user preferences, constraints, success criteria, and likely crate/module shape. Produce a high-level direction, not a full implementation plan.
2. **Research**: Inspect the workspace and established external crates before inventing new infrastructure, types, protocols, parsers, or frameworks.
3. **Architecture**: Choose concrete crate boundaries, dependencies, feature flags, public APIs, error boundaries, and test strategy.
4. **Implementation**: Make the smallest coherent code change using the repository's existing style and reusable types.
5. **Testing**: Add or update focused tests, then run the narrowest useful verification before broadening.
6. **Refining**: Compare the result against the original purpose and user preferences. Simplify, remove accidental abstractions, and return to design or architecture if the work no longer fits.

## Default Workflow

1. Identify the active phase from the user's request and repository state.
2. Inspect module boundaries, call sites, existing types, error types, dependencies, and tests before editing.
3. Before introducing new structs, traits, crates, or architecture, check whether existing project types or established crates already fit the need.
4. Preserve public APIs unless the request or surrounding design justifies changing them.
5. Add or update tests when behavior, parsing, error handling, concurrency, or public contracts change.
6. Run the narrowest useful verification first, then broader checks when the blast radius is larger.
7. Refine the result against the goal and loop back to an earlier phase when needed.

## Reference Map

Read only the reference that matches the work:

- `references/design.md` for high-level project direction, user preferences, constraints, success criteria, and initial crate/module shape.
- `references/research.md` before proposing new infrastructure, types, dependencies, parsers, protocols, or architecture.
- `references/architecture.md` for concrete crate boundaries, public APIs, feature flags, dependency choices, and compatibility decisions.
- `references/code-structure.md` for `mod.rs` APIs, sibling implementation files, public/private modules, file splitting, and where code should live.
- `references/implementation.md` for Rust coding practice around ownership, reuse, traits, async, visibility, invalid states, and refactor judgment.
- `references/error-handling.md` for `Result`, `anyhow`, custom errors, and user-facing diagnostics.
- `references/testing.md` for deciding what tests to add and how broad verification should be.
- `references/refining.md` after implementation or review to assess fit, simplify, and decide whether to loop back.

## Refactoring Rule

Refactor when it reduces actual maintenance cost in the touched area. Avoid broad cleanup while fixing narrow behavior. If duplication exists, first check whether it is accidental repetition, intentionally local clarity, or caused by missing module boundaries.
