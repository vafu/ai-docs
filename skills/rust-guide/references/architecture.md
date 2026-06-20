# Architecture Phase

Use this phase when the design is known and the task needs concrete crate boundaries, APIs, dependencies, feature flags, or compatibility decisions. For module layout and file organization, read `code-structure.md`.

## Crate Boundaries

Separate shared contracts from implementations when dependency direction matters:

- An `api`, `protocol`, or `types` crate owns shared traits, DTOs, domain contracts, request/response types, parse/encode helpers, and errors that multiple components need.
- A `core`, `runtime`, `provider`, or concrete client crate owns implementations and may depend on the shared contract crate.
- Consumers that only need types, traits, schemas, or protocol messages should not need async clients, concrete stores, tracing wrappers, or runtime implementations.

Stabilize public APIs from the outside inward: external protocol/client crate first, plugin/provider traits next, runtime adapters after that, core implementation last.

## Public Surface

Keep public API traits, structs, type aliases, constructors, public functions, and intentional re-exports discoverable from `lib.rs` or module roots. Implementation modules should not be the primary place a consumer discovers the crate contract.

Document every public-facing API at the point where consumers discover it. Public traits, structs, enums, functions, constructors, type aliases, re-exports, feature flags, and modules should explain purpose, important invariants, expected usage, and compatibility expectations. Do not leave consumers to infer behavior from implementation files.

Use private modules and `pub(crate)` until external use is real. Re-export intentionally when the surface is part of the crate contract.

Use a curated `prelude` when normal consumers need many traits and value types together. A prelude should re-export the recommended everyday API, not everything public.

Gate optional consumer-facing implementations behind feature flags when they add dependencies, runtime assumptions, or implementation policy. Keep stable contracts available with `default-features = false`.

## Output

For architecture work, define concrete crate boundaries, public API shape, API documentation expectations, dependency choices, feature flags, error boundaries, test strategy, and compatibility risks. Move back to research if the crate or API choice is still speculative.
