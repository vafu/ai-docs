---
name: proj
description: Use when starting, planning, continuing, or completing substantive project work; tracking current goals, tasks, or subtasks; or working with the proj CLI. Instructs agents to maintain the project's durable checklist and active goal, and use associated Markdown notes for plans, context, progress, and verification evidence.
---

# Proj — Project Goals and Agent Workflow

Use `proj` throughout substantive project work. Read the current goal before
planning, reuse relevant tasks, keep progress current, and record durable context
in their notes. A session-local todo tool can track immediate execution steps;
the project's goals and subtasks should remain discoverable through `proj`.

`proj` is the CLI client of the persistent `projd` service. Use it for project
and checklist metadata. Use normal file tools for the returned Markdown note
paths. Do not edit SQLite, locus relations, or service state files directly.

## Start or Resume Work

Run from the working project:

```sh
proj metadata --json
proj goal active
proj goal list --json
```

1. Resolve the project and inspect the active goal and existing checklist.
   `goal active` returns JSON or `null`; `goal list` defaults to the current
   project's goals. Each Git checkout/worktree is a separate project.
2. If an active goal matches the user's request, use it as the default focus.
   Read its description, relevant subtasks, and associated note before making
   a new plan. If it is a subgoal, follow `parent_id` with `goal show` and read
   its parent goal's context too. The user's current request takes precedence
   over a stale goal.
3. Reuse an existing relevant goal rather than creating duplicates. Use the ID
   returned by creation or listed in JSON; do not guess it from the title.
4. For an intentionally chosen, unregistered project, register its working
   directory explicitly with `proj add /absolute/checkout --name "Project name"`.
   First distinguish an unregistered project from an unavailable service.
   Do not register incidental directories, dependencies, plugins, or every
   directory discovered during a search.

Inspect the chosen goal and locate its note:

```sh
proj goal show GOAL_ID
proj goal note GOAL_ID
```

`goal show` emits JSON. `goal note` prints the exact file path to read/edit;
use that path rather than reconstructing it. Preserve existing notes and logs.

## Plan With Goals and Subtasks

For a substantial request with no suitable existing goal, create a concise,
user-recognizable goal. Its description should state the intended outcome,
scope, constraints, and observable completion criteria.

```sh
proj goal add --title "Implement project search" \
  --description "Support name/path search, preserve existing selection, and verify matching and empty results."
# Save the returned ID as GOAL_ID.
proj goal status GOAL_ID in-progress

proj goal add --parent GOAL_ID --title "Implement search and filtering" \
  --description "Match project names and paths without changing the selected project."
# Save the returned ID as SUBGOAL_ID, then track this concrete step.
proj goal start SUBGOAL_ID
proj goal add --parent GOAL_ID --title "Verify search behavior" \
  --description "Check matching, no results, clearing search, and selection preservation."
```

- Break substantial work into small, verifiable subtasks. Subtasks inherit
  their parent's project and can themselves have subtasks.
- An in-progress, multi-step goal should normally have a concrete in-progress
  subgoal associated with the work being done now. Reuse or create that subgoal
  and track it; do not leave all implementation work logged against the parent.
  A genuinely atomic task can be worked on directly without artificial children.
- New tasks are persistent: no date is required, and they do not expire at
  midnight. Use daily goals only when the user's plan calls for them.
- Store the checklist in `proj`. Put rationale, implementation approach,
  ordering/dependencies, discoveries, and unresolved questions in the note.
  Do not maintain a competing authoritative Markdown checkbox list.
- Prefer generated IDs for new goals. For an intentionally repeatable named
  goal, use `proj goal set myproject-project-search --title "Implement project search"`.
  Named persistent IDs are shared across projects, so include a project prefix.
  `set` creates a named goal or updates its title/description; it preserves
  existing status and note contents.
- Update descriptions as the plan becomes clearer, retaining the user's
  actual objective rather than replacing it with a tool-activity log:

```sh
proj goal update GOAL_ID --description "Refined scope and completion criteria"
```

## Keep Current Goal and Progress Accurate

```sh
proj goal status GOAL_ID in-progress
proj goal start SUBGOAL_ID
proj goal complete SUBTASK_ID
proj goal status SUBTASK_ID todo
```

- `start` marks a task **in progress** and selects it as the project's active
  goal. `active GOAL_ID` selects an open task without changing its status.
- Each project has one active goal, while several tasks can be in progress.
  Active selection is shared project state, not private to an agent session.
- Normally mark the overarching goal in progress, then use `start SUBGOAL_ID`
  for the concrete step being worked on. The shell shows its parent-goal context
  alongside the current subgoal. Keep the parent in progress until its whole
  scope is verified. Parallel agents/subagents should update assigned subtasks
  with `goal status` without replacing another agent's or the user's selection.
- Complete a subtask as soon as its own criteria are verified. This does not
  automatically complete its parent. Completing a parent does not complete
  its children either; review the whole plan before finishing the parent.
- Valid statuses are `planned` (`todo` is a CLI alias), `in-progress`,
  `completed`, and `deferred`. Record blockers in the note; do not invent a
  `blocked` status. Use `deferred` for explicitly postponed work.
- `goal update` changes title/description; `goal status` changes status. Prefer
  these focused commands so concurrent edits do not overwrite unrelated state.

## Use Notes for Continuity and Evidence

Each goal/subtask gets a Markdown file on creation, normally under
`~/.local/state/proj/goals/`. Its initial template contains a title, description,
Notes, and Log sections. State-directory overrides and dated goals can change
the path, so always obtain it with `proj goal note ID`.

Use the note to record:

- The plan, relevant constraints, design decisions, and links to context.
- Progress at meaningful milestones, especially before pausing or handing off.
- Blockers, remaining work, and the next concrete action.
- Verification commands and results, artifacts, and evidence for completion.

Append or make focused edits with ordinary file tools. Preserve prior context
and other agents' contributions. Metadata/status updates never rewrite the
note. The description and checklist remain authoritative in `proj`; editing
Markdown does not change task status or the title shown on the bar.

`proj goal note ID --open` opens the note in `$EDITOR` for interactive use.
Agents should normally read/edit the file directly with tools rather than
launching an editor or manipulating desktop focus.

## Finish or Hand Off

1. Verify the actual completion criteria, not just that commands ran or the
   agent became idle. Record supporting evidence and outstanding limitations
   in the relevant note and final response.
2. Mark only the tasks whose scope is complete. Leave an overarching goal open
   if any of its requested work remains. Personal habits require the user's
   judgment, not inferred completion from coding activity.
3. For incomplete work, keep an honest status and record what remains, the
   blocker if any, and how the next agent can resume.
4. Completing, deferring, or removing the active task clears its selection.
   `proj goal active --clear` merely stops tracking; it does not complete it.
   Select the next concrete subgoal when continuing work on the same objective;
   restore the parent selection only when there is no current step to track.

## Command Reference

| Intent | Command |
| --- | --- |
| Current project's goals | `proj goal list --json` |
| Another project's goals | `proj goal list --project /absolute/project --json` |
| All goals, including history/global tasks | `proj goal list --all --json` |
| Current active goal | `proj goal active` |
| Inspect a goal | `proj goal show ID` |
| Create a goal | `proj goal add --title TITLE --description DESCRIPTION` |
| Create a subtask | `proj goal add --parent ID --title TITLE` |
| Named create/update | `proj goal set PROJECT_SCOPED_ID --title TITLE` |
| Edit metadata | `proj goal update ID --title TITLE --description DESCRIPTION` |
| Begin and track work | `proj goal start ID` |
| Select without changing status | `proj goal active ID` |
| Update status | `proj goal status ID STATUS` |
| Complete | `proj goal complete ID` |
| Get note path | `proj goal note ID` |
| Refresh existing Git metadata | `proj update` |

`proj task` is an alias for `proj goal`. Use `--date YYYY-MM-DD` for dated goals
and the full `date/ID` key when historical IDs are ambiguous. `goal add --active`
selects the new task but leaves its initial status planned; `goal start` performs
both selection and the in-progress transition. Remove subtasks before removing
their parent; removal retains the Markdown note.

If the installed CLI differs, inspect `proj --help` and `proj goal --help`.
If `proj` or its service is unavailable, report that tracking could not be
updated, keep a temporary session plan, and synchronize it when service access
returns. Do not fabricate a successful status update or build a replacement
project-management store.
