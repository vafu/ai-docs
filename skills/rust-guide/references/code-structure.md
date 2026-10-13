# Code Structure

Use this reference when deciding where code should live inside a crate or module.

## Module Roots

Within a crate, organize major features as `<feature>/mod.rs` plus sibling implementation files:

```text
src/
  feature/
    mod.rs
    service.rs
    repository.rs
    test.rs
```

Use `mod.rs` as the feature's crate-local API. Put public traits, structs, enums, type aliases, constructors, public functions, and re-exports there. Put implementation details in sibling files; prefer `mod sibling;` over `pub mod sibling;`.

Keep public API traits, structs, type aliases, constructors, public functions, and intentional re-exports discoverable from `lib.rs` or module roots. Implementation files should not be the primary place a consumer discovers the crate or feature contract.

Document public-facing APIs in `lib.rs` or module roots alongside the item or re-export consumers use. Documentation should state what the API is for, what invariants or lifecycle rules matter, and when consumers should choose it over nearby alternatives.

## Public And Private Modules

Use private modules and `pub(crate)` until external use is real. Re-export intentionally when the surface is part of the crate contract.

Prefer `pub use` from module roots over exposing implementation module paths. Consumers should depend on stable concepts, not file layout.

## Implementation Files

Keep an implementation file focused on one primary struct or one tightly related responsibility. Multiple inherent impl blocks and multiple trait impls for that struct can live together.

If a file contains several unrelated struct implementations, look for a missing feature boundary, a missing trait, or a type that belongs in its own sibling file.

## Split Candidates

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

## Tests

Place module tests in `test.rs` inside the module directory when the code already uses feature directories or when the change creates one. Wire it from `mod.rs` with `#[cfg(test)] mod test;`. See `testing.md` for broader test strategy.
