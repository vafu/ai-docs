# Design Phase

Use this phase when the user asks what to build, how to shape the project, or whether a direction makes sense.

## Goals

Clarify the original purpose, target user, concrete user preferences, non-goals, constraints, and success criteria. Keep the design tied to the problem being solved rather than to an implementation idea.

Capture the likely crate and module shape at a high level: which responsibilities exist, which contracts may need to be shared, and which parts should remain local until proven useful.

## Reuse First

Before inventing project structure, inspect the existing workspace for crates, modules, domain types, feature flags, and conventions that already imply the design. Prefer extending the existing shape when it fits.

If a design depends on a well-known domain such as parsing, protocol handling, storage, routing, async orchestration, config, telemetry, or serialization, move to the research phase before proposing custom infrastructure.

## Output

For design work, produce:

- The problem and success criteria.
- Relevant user preferences and constraints.
- A high-level crate/module direction.
- The main risks or unknowns that require research.
- A clear next phase: research, architecture, implementation, or no change.
