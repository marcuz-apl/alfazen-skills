---
name: alfazen-versioning
description: Use when an AI coding assistant needs to establish or audit bounded m.n.p Git versioning, automatic per-commit patch bumps, UTC build timestamps, or versioned commit-message hooks.
---

# Alfazen Versioning

Apply one language-independent versioning contract to a Git project. Keep the
current version in a tracked root `VERSION` file and use versioned Git hooks to
bump it before each created commit and stamp the commit subject.

## Version contract

- Initialize `VERSION` with `1.0.0` when it does not exist.
- Accept only `m.n.p`, where `m` is a non-negative decimal integer and `n` and
  `p` are single digits `0`–`9`.
- Bump `p` for every commit that runs the hooks.
- When `p` is `9`, reset it to `0` and increment `n`.
- When `n` is `9`, reset it to `0` and increment `m`.
- Therefore `1.0.8 → 1.0.9 → 1.1.0` and `1.9.9 → 2.0.0`.
- Reject malformed versions; never silently clamp, skip, or repair a value.
- Treat `VERSION` as the single source of truth. Do not derive it from tags,
  commit count, timestamps, or commit messages.

## Configure a repository

1. Read the repository instructions and existing Git configuration first.
2. Confirm the project wants this contract before changing files.
3. Create a tracked root `VERSION` containing `1.0.0` if absent.
4. Create a versioned `.githooks/` directory.
5. Activate it with:

   ```sh
   git config core.hooksPath .githooks
   ```

6. Keep hook entrypoints thin and place reusable version logic in a small
   project-local script.
7. Run the validation checklist before claiming completion.

## Required hooks

### `.githooks/pre-commit`

Read `VERSION`, validate it, compute exactly one next version, write only
`VERSION`, and stage only `VERSION`. Preserve every other staged file and its
staged contents.

If the commit is rejected or aborted after the bump, explain that the working
tree may contain the incremented version. Offer this safe rollback path when a
previous commit exists:

```sh
git restore --source=HEAD --staged --worktree -- VERSION
```

Do not replace this with `post-commit`; the commit must contain the new version.
Do not create an automatic follow-up commit.

### `.githooks/prepare-commit-msg`

Git invokes this hook after `pre-commit` in the normal commit flow. Read the
already-bumped `VERSION` and rewrite only the first non-comment subject line.
Use UTC and this exact prefix format:

```text
m.n.p build yyyy-mm-dd-hhmm feat: original message
```

Example:

```text
1.1.0 build 2026-08-11-1430 feat: add parser
```

Strip one existing matching prefix before adding the current prefix. This must
be idempotent for repeated execution, amend, rebase, and cherry-pick. Preserve
the message body, blank lines, and trailers. Preserve the original
Conventional Commit type; never turn `fix:` into `feat:`.

Use a locale-independent UTC formatter. On Windows, remember that Git executes
POSIX shell hooks through its bundled shell; do not assume the current working
directory or a Unix-only external installation.

## Commit policy

Default to stamping every commit for which the hooks run, including merge,
empty, amend, cherry-pick, and rebase-created commits. Document any deliberate
project-specific exception.

Client hooks can be bypassed with `--no-verify`; do not claim they enforce a
team-wide policy. If enforcement matters, add CI or server-side validation as a
separate, explicitly requested change.

Do not add a database, hidden write bypass, feature-flagged source mutation,
unrelated release automation, or a second version source.

## Validation checklist

Use a disposable test repository or temporary clone. Verify:

- `1.0.9` becomes `1.1.0`.
- `1.9.9` becomes `2.0.0`.
- A normal commit contains the bumped `VERSION` and one stamped subject.
- A commit with staged files besides `VERSION` preserves those files.
- Amend does not duplicate the prefix and bumps once.
- Repeated `prepare-commit-msg` execution does not duplicate the prefix.
- Message bodies and trailers are unchanged.
- Malformed versions are rejected without a silent correction.
- Only `VERSION` is modified by `pre-commit`.
- `git config --get core.hooksPath` returns `.githooks`.
- Hashing an image or other test source before and after any project-specific
  workflow shows exact equality when source integrity matters.

Inspect the final subject with `git log -1 --format=%s` and the final staged
set with `git diff --cached --name-only`.

## Common mistakes

- Rewriting the message in `pre-commit`: use `prepare-commit-msg`.
- Reading the old version in `prepare-commit-msg`: read the bumped `VERSION`.
- Using local time: format the timestamp in UTC.
- Staging all files from the hook: stage only `VERSION`.
- Appending metadata during amend/rebase: strip the matching prefix first.
- Changing commit types: preserve `fix:`, `docs:`, `refactor:`, and other
  existing types.
- Claiming hooks cannot be bypassed: disclose the `--no-verify` limitation.
