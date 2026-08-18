---
name: handoff
description: Use when a user requests a project handoff, session checkpoint, milestone summary, pause/resume note, or continuation instructions in HANDOFF.md.
---

# Handoff

Create or update a concise, factual `HANDOFF.md` that lets another agent or
the user resume work safely. Treat the file as the current project snapshot,
not as a chat transcript or an event log.

## Trigger policy

Use this skill when the user explicitly requests a handoff or when they ask to
checkpoint work at a milestone, pause, blocker, context boundary, or planned
session transition. Do not claim to detect logout automatically; agent
sessions generally cannot observe logout reliably.

Do not create a handoff merely because a normal task ended successfully unless
the user asks for one or the project workflow explicitly requires checkpoints.

## Workflow

1. Read repository instructions and the existing `HANDOFF.md`, if present.
2. Inspect the current Git state:

   ```sh
   git status --short --branch
   git log -1 --oneline --decorate
   git diff --stat
   ```

3. Inspect only the focused files, tests, and logs needed to establish the
   current state. Do not dump unrelated files or file contents into the
   handoff.
4. Run only relevant checks when they are safe and reasonably quick. Record
   the exact commands and whether they passed, failed, or were not run.
5. Update `HANDOFF.md` in the repository root using the template below.
6. Review the resulting file for stale claims, missing blockers, secrets, and
   unsupported statements.
7. Show the user what was captured and the next recommended action.

Do not automatically commit or push `HANDOFF.md`. Ask before making that
separate Git operation. Do not modify unrelated files.

## Handoff template

Use this structure and keep each section brief:

```markdown
# Project Handoff

Updated: YYYY-MM-DD HH:MM UTC
Branch: <branch>
Commit: <short commit or "no commits yet">
Status: <in progress | blocked | ready for review | complete>

## Summary

<What the project or task is doing and the current result.>

## Completed

- <Completed item, with a relevant file or commit when useful.>

## In progress

- <Current work and its exact location.>

## Working tree

- <Tracked/untracked/unstaged changes, or "clean".>

## Checks

- `<command>` — PASS / FAIL / NOT RUN (<short reason>)

## Decisions and context

- <Decision that a future agent must not rediscover or reverse accidentally.>

## Blockers

- <Concrete blocker, or "None".>

## Next action

1. <The smallest concrete next step.>

## Resume notes

- <Relevant paths, commands, assumptions, or safe setup details.>
```

Replace template marker text with project-specific facts. Remove sections that are
genuinely irrelevant only when doing so does not hide state; keep `Blockers`
and `Next action` explicit.

## Accuracy and safety rules

- Prefer current command output over memory or assumptions.
- Distinguish completed, attempted, and planned work.
- Record failures and blockers instead of disguising them as pending work.
- Include exact file paths and commands when they make resumption faster.
- Never include credentials, access tokens, private keys, secrets, or copied
  sensitive file contents.
- Do not claim tests passed unless they were run in the current state.
- Do not invent a clean working tree, commit, deployment, or external result.
- Do not use `HANDOFF.md` to weaken repository safety rules.

## Updating an existing handoff

Read the existing file before editing it. Preserve useful manually written
context, but replace stale status, branch, commit, working-tree, checks, and
next-action facts with the current evidence. Keep one current snapshot by
default; append a dated history only when the user explicitly asks for a log.

If the working tree already contains user edits to `HANDOFF.md`, preserve them
and avoid overwriting content outside the sections being refreshed. If that
cannot be done safely, stop and ask before replacing the file.

## Common mistakes

- Treating logout as a reliable trigger: use explicit checkpoints instead.
- Writing a long transcript: capture decisions and resumable state.
- Omitting the next action: every handoff needs a concrete restart point.
- Reporting stale test results: rerun or mark the check as not run.
- Committing automatically: let the user decide whether the handoff belongs in
  project history.
- Including secrets or raw logs: summarize them without copying sensitive data.
