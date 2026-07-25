---
name: codex-review
description: Ask Codex CLI (gpt-5.5) for an independent code review of uncommitted changes, branch diff, a commit, or a specific implementation. This is how gpt-5.5 is invoked for review work. Use when the user asks Claude to have Codex or gpt-5.5 review work, when the model-selection rubric calls for a gpt-5.5 review perspective, or when Codex should audit a diff, find bugs or regressions, or compare Claude's implementation against requirements. For a review by Claude itself, use the normal review process instead.
---

# Codex Review

Use Codex as an independent reviewer when the user wants a second-pass review
or when a change is broad enough that another agent's perspective is useful.

Prefer Claude's normal review process for small local checks.  Do not delegate
review just to avoid reading the code yourself.  Treat Codex's output as
evidence, not authority.

## Workflow

1. Identify the review target: uncommitted changes, base branch, commit SHA,
   PR checkout, or specific files.
2. Create a temporary artifact directory for the Codex report.
3. Run `codex exec` with a focused review prompt.
4. Read Codex's report and verify important claims against the code before
   presenting them.

Use this command shape:

```bash
ARTIFACT_DIR="$(mktemp -d "${TMPDIR:-/tmp}/codex-review.XXXXXX")"
REPORT="$ARTIFACT_DIR/report.md"
PROMPT="$ARTIFACT_DIR/prompt.md"

codex exec -s read-only -C "$PWD" --output-last-message "$REPORT" - < "$PROMPT"
```

If the report file comes back empty, Codex likely crashed executing a command
rather than producing a final answer — check `stderr` for a tool-call failure
(e.g. a sandbox/tmpdir error from re-running tests) and retry with an explicit
instruction in the prompt for how to avoid the error.

## Review Prompt

Ask Codex to use a code-review stance:

```text
Review these changes for bugs, regressions, missing tests, security issues,
and requirement mismatches.

Prioritize findings over summary.  For each finding include:
- severity
- file and line reference
- concrete failure mode
- suggested fix direction

Do not edit files.  If there are no substantive findings, say so and name any
residual test gaps.

Do not run the test suite, linter, or type-checker unless you need their
output for something code-reading alone can't tell you.  If a sandboxed
command fails for environment reasons (e.g. a missing writable temp
directory), treat that as a tooling limitation, not a finding.
```

Add review scope to the prompt.  Some possible examples:
- review should be scoped to staged, unstaged, or untracked changes
- review the current branch against a base branch
- review a single commit by specifying the SHA hash

Add task-specific context when useful: requirements, risky areas, expected
behaviour, relevant tests, or files Claude is unsure about.

Along with the instruction for codex to avoid running the tests/linting
commands, state in your prompt whether the test suite, linter, or type-checker
already pass.

## Reporting Back

Before relaying a Codex finding, inspect the cited code or diff enough to
decide whether the finding is real.  In the user-facing response, separate
confirmed issues from Codex suggestions you did not verify.

If Codex finds nothing, say that clearly and mention what review target it
inspected.

If `codex` is not installed or the command fails, report the error and offer
to review the changes directly instead.
