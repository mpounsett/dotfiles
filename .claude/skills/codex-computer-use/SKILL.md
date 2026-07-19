---
name: codex-computer-use
description: Ask Codex CLI (gpt-5.5) to run local app verification that needs computer use, browser automation, simulators, screenshots, app launching, or independent runtime inspection. This is how gpt-5.5 is invoked for computer-use work. Use when the user asks Claude to test a flow, verify UI behaviour, inspect a running app, capture screenshots, or report confirmation and feedback about implemented behaviour that benefits from computer use functionality.
---

# Codex Computer Use

Use Codex as a separate local verification agent when the task needs a real UI
interaction, screenshots, simulator/browser/device state, or an independent
runtime check outside Claude's current context.

Do not use this for ordinary code reading, type-checking, linting, or tests
Claude can run directly.  Launching apps, simulators, or browsers to verify
the requested work is fine without asking; ask first only if the run could
disrupt the user's environment beyond that (closing their apps, changing
system settings, acting on real accounts or data).

## Workflow

1. Create a temporary artifact directory.
2. Give Codex a self-contained prompt with the repo path, exact flow,
   constraints, artifact directory, and report format.
3. Run `codex exec` non-interactively.
4. Read Codex's report, inspect or reference screenshot paths, and summarize
   the result for the user.

**Artifact paths are easy to lose track of — be explicit and defensive.**
`-o "$REPORT"` only captures the agent's final message; it does not control
where screenshots get saved. When Codex uses its native screen-capture tool
(rather than a CLI/Playwright screenshot), that tool has its own default
save location independent of `--add-dir`, observed in practice to be
`<repo>/tmp/GPT/<task-slug>/`. Two things prevent artifacts from going
missing:
- Interpolate the literal resolved `$ARTIFACT_DIR` path into the prompt
  *text* itself (e.g. "Save screenshots to /var/folders/.../codex-computer-use.XXXXXX/
  using these exact filenames: ..."). Referring to it only as "the artifact
  directory" without ever writing out the path gives Codex nothing concrete
  to target, and it will fall back to its own convention.
- Also instruct Codex, as its last step, to copy (not move) every
  screenshot and its report into `$ARTIFACT_DIR` regardless of where they
  were first written — this normalizes the location even if Codex's tools
  ignored the earlier instruction. If artifacts still aren't in
  `$ARTIFACT_DIR` afterward, check `<repo>/tmp/GPT/` before concluding the
  run produced nothing.
  

Use this command shape:

```bash
ARTIFACT_DIR="$(mktemp -d "${TMPDIR:-/tmp}/codex-computer-use.XXXXXX")"
REPORT="$ARTIFACT_DIR/report.md"
PROMPT="$ARTIFACT_DIR/prompt.md"

# Write a self-contained prompt to $PROMPT, then run:
codex exec \
  -C "$PWD" \
  --add-dir "$ARTIFACT_DIR" \
  -s danger-full-access \
  -o "$REPORT" \
  "$(cat "$PROMPT")"
```

Use `-s danger-full-access` for GUI automation, iOS simulators, desktop app
launching, screenshots, or access outside the repo.  For non-GUI checks that
only need the repo and artifact directory, prefer `-s workspace-write`. Add
`--skip-git-repo-check` when the working directory is not a git repository.

## Prompt Requirements

Tell Codex:

- The exact behaviour to verify.
- The platform and app type, such as iOS, web, Electron, CLI, or desktop.
- Known launch commands, test credentials, seed data, deep links, or fixtures.
- Whether source edits are allowed.  Default to no edits.
- Where screenshots, logs, and the final report should be saved — give the
  literal resolved `$ARTIFACT_DIR` path in the prompt text, and ask Codex to
  copy final artifacts there as a last step even if intermediate tools saved
  them elsewhere.
- To return pass, fail, or blocked, plus steps performed, observed behaviour,
  screenshot paths, and actionable feedback.

Keep the prompt specific enough that Codex does not need the surrounding
Claude conversation.


