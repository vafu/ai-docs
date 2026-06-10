# Module Boundaries

Use module boundaries to make ownership and responsibility clearer, not just to shorten files.

## When To Split

Split when a section has a stable concept, independent tests, a different dependency profile, or multiple call sites that would benefit from a named API. Keep code local when extraction would make readers bounce between files without reducing complexity.

For multi-component systems, prefer an `api` crate plus a `core` crate:

- `api` owns shared traits, DTOs, domain contracts, request/response types, and errors that multiple components need.
- `core` owns the concrete runtime implementation and may depend on `api`.
- Other crates should depend on `api` alone when they only need contracts, schemas, or trait bounds.

Inside an individual crate, prefer feature directories:

```text
src/
  feature/
    mod.rs
    service.rs
    repository.rs
    test.rs
```

Use `mod.rs` as the crate-local API for the feature. It should expose public traits, public structs, and intentional re-exports. Put implementation details in sibling files.

Good split candidates:

- Domain types and serialization schemas.
- Pure formatting helpers.
- Adapters around external tools or services.
- Reusable validation logic.
- Long command/tool handlers whose bodies repeat the same execution pattern.
- A primary struct whose behavior has grown enough to deserve its own file.

Weak split candidates:

- One-off helpers with only one caller.
- Tiny modules named after implementation details.
- Files split only because they crossed an arbitrary line count.

## Redundancy Review

When reviewing duplicated Rust code, classify it before editing:

- Same validation or conversion repeated across handlers: extract a helper or trait if the abstraction remains readable.
- Similar code with different domain behavior: keep separate unless a shared helper preserves the differences clearly.
- Repeated boilerplate from a framework macro: reduce around the macro only if the macro still sees the shapes it requires.

## Implementation Files

Keep an implementation file focused on one primary struct. Multiple inherent impl blocks and multiple trait impls for that struct can live together. If a file contains several unrelated struct implementations, look for a missing feature boundary, a missing trait, or a type that belongs in its own sibling file.

Prefer traits for functional behavior: services, repositories, executors, formatters, clients, and adapters should usually have a trait in `mod.rs` with the concrete implementation in a sibling file. This is still useful with one implementation because it makes composition and testing boundaries explicit.

## Public Surface

Prefer private modules and `pub(crate)` until external use is real. Re-export intentionally from `lib.rs` or module roots when that surface is part of the crate contract.
