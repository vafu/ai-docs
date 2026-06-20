# Implementation Phase

Use this phase when editing Rust code.

## Reuse Types First

Before defining a new struct, enum, or type alias, search the crate and nearby workspace crates for an existing type that already represents the concept. Reuse the existing type when its invariants and ownership model fit. Create a separate type only when it carries a genuinely different invariant, lifecycle, serialization contract, API boundary, or dependency direction.

Prefer adapting behavior around existing domain types over creating parallel request, config, state, or result structs. Parallel types are justified when they intentionally separate wire format from domain model, public API from internal state, borrowed input from owned storage, or untrusted input from validated data.

## Rust Practice

Model ownership explicitly. Avoid cloning to silence borrow errors unless the data is cheap or the clone clarifies ownership.

Prefer borrowing at internal boundaries and owned values at persistence, task, thread, or API boundaries where lifetimes would leak implementation details.

Use iterators where they clarify data flow. Use loops when mutation, early exits, async steps, logging, metrics, or error paths become easier to read.

Make invalid states hard to represent when doing so removes meaningful runtime checks without overcomplicating construction.

Prefer trait-backed designs for functional behavior such as services, repositories, executors, formatters, clients, and adapters when that boundary helps composition or testing. Keep traits private or `pub(crate)` until a real external contract exists.

Keep async boundaries deliberate. Do not hold locks across `.await` unless the lock type and critical section are intentionally designed for it.

## Refactor Judgment

Refactor in the touched area when it makes the requested change clearer, reduces real duplication, or exposes a stable concept. Avoid broad cleanup while fixing narrow behavior.

If implementation reveals a poor fit with the design or architecture, stop and return to that phase instead of forcing the code through.
