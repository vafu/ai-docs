# Refining Phase

Use this phase after implementation, during review, or when the result feels larger than the goal.

## Fit Check

Compare the current result against:

- The original user goal and success criteria.
- Stated user preferences and constraints.
- The existing project architecture and naming.
- Public API stability and dependency direction.
- Test coverage for the behavior that changed.

## Simplify

Remove accidental abstractions, duplicate types, unused feature flags, speculative traits, excessive conversions, and custom code that an existing project type or crate already handles.

Check whether new structs, enums, modules, crates, or dependencies still have a clear reason to exist. Merge them back when separation no longer carries a distinct invariant, API boundary, lifecycle, dependency direction, or testable responsibility.

## Loop

Return to design if the result no longer fits the purpose. Return to research if custom infrastructure looks unnecessary. Return to architecture if crate boundaries, APIs, or dependencies need to change. Return to implementation only after the direction is clear.
