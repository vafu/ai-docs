# Error Handling

Choose error style based on boundary.

## Library Code

Use typed errors when callers can recover, branch, or present different messages. Preserve source errors with `#[source]` or transparent variants when using `thiserror`.

Use `anyhow` sparingly in library internals, mainly where the crate already treats the path as operational glue and no caller needs to branch on the error.

## Binary And Tool Code

Use `anyhow::Context` for operational failures where the immediate goal is a useful diagnostic. Add context at the boundary where intent is clearest:

```rust
let config = load_config(path)
    .with_context(|| format!("failed to load config from {}", path.display()))?;
```

Avoid adding context that only repeats the callee name.

## User-Facing Errors

For CLI, MCP, HTTP, or UI boundaries, convert internal errors into messages with enough detail to act. Keep internal debug details out unless the existing project exposes them.

Prefer validating inputs before performing side effects when invalid inputs are expected user mistakes.

