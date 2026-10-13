---
name: interactive-reviewer
description: Run collaborative, interactive code review sessions with live note tracking. Use when Codex should inspect a repository crate-by-crate or module-by-module, optionally delegate bounded read-throughs to subagents when explicitly requested, explain what code does, capture user review notes in durable files, and produce per-crate refactor plans plus global review guidance.
---

# Interactive Reviewer

## Operating Mode

Act as the review coordinator for a human-led code reading session. Keep momentum by separating factual code explanation, reviewer notes, open questions, and refactor planning.

Do not turn the session into broad implementation unless the user explicitly asks. The default deliverable is understanding plus durable notes.

## Start A Session

1. Read local repository instructions before planning: `AGENTS.md`, project roadmaps, architecture notes, and package manifests relevant to the repo.
2. Identify the review units from the codebase. Prefer crates for Rust workspaces, packages for JS/TS workspaces, modules for smaller repos, and bounded subsystems for monorepos.
3. Create or update a review directory. If the user does not specify paths, use `refactor/readme.md` for global notes and `refactor/<unit-name>.md` for unit notes.
4. Record global constraints, review queue, completed units, cross-cutting findings, and user-wide guidance in the global note file.

## Delegation

Use subagents only when the user explicitly asks for agents, delegation, or parallel review work.

Give each agent one bounded read-through. Ask for:

- What the unit does in practical terms.
- Public API and entrypoints.
- Internal module structure.
- Important dependencies and runtime behavior.
- Existing tests and verification gaps.
- Boundary or ownership concerns.
- Suggested reading order for the human reviewer.
- Possible refactor themes, clearly separated from factual behavior.

While an agent reads one unit, do non-overlapping local work: prepare note files, read repo-level guidance, inspect manifests, or review a different bounded area. Do not duplicate the delegated read-through unless you need a narrow check before writing final notes.

## Unit Review Flow

For each crate, package, module, or subsystem:

1. Read the manifest, root entrypoints, public types, major modules, tests, and examples.
2. Explain what the unit does before giving opinions. Mark inferences as inferences.
3. Give the human a useful reading path through the files.
4. Capture user notes as they arrive. Preserve raw intent, then add categorization only when helpful.
5. Track unresolved questions separately from accepted refactor items.
6. When the unit is done, write or update `refactor/<unit-name>.md` with a larger refactor plan.

## Note Discipline

Keep notes durable and easy to resume from.

Use `refactor/readme.md` for:

- Session scope and review queue.
- Global architecture constraints.
- Cross-unit themes.
- Decisions that affect multiple units.
- Open questions that are not owned by one unit.

Use `refactor/<unit-name>.md` for:

- Current role of the unit.
- Public surface and entrypoints.
- Internal structure.
- Factual behavior summary.
- User review notes.
- Findings and risks.
- Refactor plan.
- Test and verification needs.
- Follow-up questions.

Do not silently delete user notes. If consolidating notes, preserve the substance and make it clear what changed.

## Suggested Unit Note Template

```markdown
# <Unit Name> Refactor Notes

## Current Role

## Public Surface

## Internal Structure

## Behavior Summary

## User Notes

## Findings

## Refactor Plan

## Tests And Verification

## Open Questions
```

## Review Standards

Prioritize boundary violations, confusing ownership, brittle APIs, missing tests, duplicated concepts, async/runtime risks, and places where names no longer match behavior.

When reviewing framework-style repositories, keep product behavior out of generic framework layers unless the repository guidance says otherwise. Cross-reference roadmap files when a finding changes architecture or responsibility boundaries, and update those roadmap files only when the user agrees the plan changed.

Prefer small, concrete refactor steps over vague rewrites. A good refactor plan names the affected files or modules, the dependency direction being fixed, and the verification needed afterward.
