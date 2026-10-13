# ai-docs

Reusable AI-agent guidance and Codex skills.

## Skills

- `skills/rust-guide` - Rust project guidance for agents working in existing Rust codebases.
- `skills/proj` - Use `proj` for current-goal tracking, durable project planning,
  nested subtasks, progress/status updates, and Markdown context notes.
- `skills/interactive-reviewer` - Collaborative review workflow with delegated code reading, durable notes, and per-unit refactor plans.

## Install

Install all skills into `${CODEX_HOME:-$HOME/.codex}/skills`:

```bash
scripts/install-skills.sh
```

Install or update one skill:

```bash
scripts/install-skills.sh --force rust-guide
scripts/install-skills.sh proj
```

Restart Codex after installing skills.
