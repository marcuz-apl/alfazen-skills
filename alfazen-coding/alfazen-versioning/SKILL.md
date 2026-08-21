---
name: alfazen-versioning
description: Use when an AI coding assistant needs to establish or audit bounded m.n.p Git versioning, per-commit patch bumps, UTC yymmddc build identifiers, or versioned commit-message hooks.
---

# Alfazen Versioning

Apply one language-independent versioning contract to a Git project. Keep the
VERSION number and BUILD number distinct, connect them as `VERSION-BUILD`, and
store that full identifier in a tracked root `VERSION` file.

## Identifier components

- The VERSION number is `m.n.p`. It is the project release/version component.
- The BUILD number is `yymmddc`, such as `260821a`. It is the seven-character
  UTC date-and-daily-counter component.
- The connected identifier is `m.n.p-yymmddc`, such as
  `1.0.9-260821a`. The dash is the only separator between VERSION and BUILD.
- The root `VERSION` file stores the connected identifier, not either component
  by itself. Hooks must parse and update the two components separately.

## Version contract

- Initialize `VERSION` with `1.0.0-<current UTC yymmdd>1` when it does not
  exist. Treat that value as the baseline; the first hook-run commit advances
  both the version and the daily counter.
- Store the connected identifier as `m.n.p-yymmddc`. The `yymmddc` BUILD number
  is exactly seven characters: six UTC date digits followed by one lowercase
  counter character.
- Accept only `m.n.p-yymmddc`, where `m` is a non-negative decimal integer,
  `n` and `p` are single digits `0`–`9`, and `yymmddc` follows the build rules
  below.
- Bump `p` for every commit that runs the hooks.
- When `p` is `9`, reset it to `0` and increment `n`.
- When `n` is `9`, reset it to `0` and increment `m`.
- Therefore `1.0.8 → 1.0.9 → 1.1.0` and `1.9.9 → 2.0.0`.
- Format the BUILD number as `yymmddc` using the current UTC date. For each UTC
  day, use the counter sequence `1` through `9`, then `a` through `z`.
- Reset the BUILD counter to `1` when the UTC date changes. If `z` has already
  been used on the current UTC date, reject the next commit rather than reusing,
  skipping, or silently changing a counter.
- Reject malformed versions, invalid calendar dates, future-dated identifiers,
  and exhausted daily counters; never silently clamp, skip, or repair a value.
- Treat the root `VERSION` file as the single source of truth for both
  components. Do not derive `m.n.p` from tags, commit count, or commit
  messages; derive only the BUILD number from the current UTC date and the
  prior `VERSION` value.

## Configure a repository

1. Read the repository instructions and existing Git configuration first.
2. Confirm the project wants this contract before changing files.
3. Create a tracked root `VERSION` containing `1.0.0-<current UTC yymmdd>1` if
   absent.
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

Read the root `VERSION` file, validate the connected `VERSION-BUILD` identifier,
compute exactly one next identifier, write only `VERSION`, and stage only
`VERSION`. Preserve every other staged file and its staged contents. Increment
`p` with the normal carry rules, then advance the daily counter or reset it to
`1` for a new UTC date.

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
already-bumped connected identifier from `VERSION` and rewrite only the first
non-comment subject line. Use this exact prefix format:

```text
m.n.p-yymmddc feat: original message
```

Example:

```text
1.1.0-260816a feat: add parser
```

Strip one existing matching `m.n.p-yymmddc` prefix before adding the current
prefix. This must be idempotent for repeated execution, amend, rebase, and
cherry-pick. Preserve the message body, blank lines, and trailers. Preserve the
original Conventional Commit type; never turn `fix:` into `feat:`.

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
- A normal commit contains the bumped `VERSION` and one subject stamped as
  `m.n.p-yymmddc <original type>: <original subject>`.
- The daily counter advances `9 → a`, and `z` is rejected when no new UTC day
  has started; a new UTC day resets the counter to `1`.
- The connected value remains intact across version carries, for example
  `1.0.9-260815z → 1.1.0-2608161` when the date changes.
- A commit with staged files besides `VERSION` preserves those files.
- Amend does not duplicate the prefix and bumps once.
- Repeated `prepare-commit-msg` execution does not duplicate the prefix.
- Message bodies and trailers are unchanged.
- Malformed, invalid-date, future-dated, and same-day-exhausted identifiers are
  rejected without a silent correction.
- Only `VERSION` is modified by `pre-commit`.
- `git config --get core.hooksPath` returns `.githooks`.
- Hashing an image or other test source before and after any project-specific
  workflow shows exact equality when source integrity matters.

Inspect the final subject with `git log -1 --format=%s` and the final staged
set with `git diff --cached --name-only`.

## Common mistakes

- Rewriting the message in `pre-commit`: use `prepare-commit-msg`.
- Reading the old version in `prepare-commit-msg`: read the bumped `VERSION`.
- Using local time: format the `yymmdd` date in UTC.
- Treating the build as eight characters or numeric-only: it is six date
  digits plus one counter character, with `a`–`z` after `9`.
- Reusing `z` after 35 same-day builds: reject until the UTC date changes.
- Staging all files from the hook: stage only `VERSION`.
- Appending metadata during amend/rebase: strip the matching prefix first.
- Changing commit types: preserve `fix:`, `docs:`, `refactor:`, and other
  existing types.
- Claiming hooks cannot be bypassed: disclose the `--no-verify` limitation.
