# Architecture Phase

Use this phase when the design is known and the task needs concrete crate boundaries, APIs, dependencies, or module layout.

## Crate Boundaries

Separate shared contracts from implementations when dependency direction matters:

- An `api`, `protocol`, or `types` crate owns shared traits, DTOs, domain contracts, request/response types, parse/encode helpers, and errors that multiple components need.
- A `core`, `runtime`, `provider`, or concrete client crate owns implementations and may depend on the shared contract crate.
- Consumers that only need types, traits, schemas, or protocol messages should not need async clients, concrete stores, tracing wrappers, or runtime implementations.

Stabilize public APIs from the outside inward: external protocol/client crate first, plugin/provider traits next, runtime adapters after that, core implementation last.

## Public Surface

Keep public API traits, structs, type aliases, constructors, public functions, and intentional re-exports discoverable from `lib.rs` or module roots. Implementation modules should not be the primary place a consumer discovers the crate contract.

Use private modules and `pub(crate)` until external use is real. Re-export intentionally when the surface is part of the crate contract.

Use a curated `prelude` when normal consumers need many traits and value types together. A prelude should re-export the recommended everyday API, not everything public.

Gate optional consumer-facing implementations behind feature flags when they add dependencies, runtime assumptions, or implementation policy. Keep stable contracts available with `default-features = false`.

## Module Layout

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

## Output

For architecture work, define concrete crate/module boundaries, public API shape, dependency choices, feature flags, error boundaries, test strategy, and compatibility risks. Move back to research if the crate or API choice is still speculative.
