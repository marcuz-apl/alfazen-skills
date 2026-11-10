---
name: versioning-prefixed
description: Add an Alfazen UTC build prefix to Git commit subjects while keeping a plain m.n.p VERSION file. Use when a project wants visible v{VERSION}+{BUILD} commit subjects and feature patch bumps without changing VERSION to a connected identifier.
---

# Prefixed versioning

Use this policy when the project wants subjects such as:

```text
v0.1.1+2611104 feat: add well import
```

This is a deliberate variation from `versioning-classic`: the subject no longer starts with a Conventional Commit type. Standard commitlint or release tooling may need a custom parser. Do not apply this skill to a repository that requires unmodified Conventional Commit subjects.

## Contract

- Keep a tracked root `VERSION` containing only `m.n.p`, with unbounded nonnegative decimal components. Preserve an existing value; initialize from the user's requested value when absent.
- For each `feat` commit, increment `p` exactly once and stage `VERSION` in that commit. Keep `m` and `n` unchanged. For `fix` and `perf`, use the project's existing bump policy; if none exists, use the same patch bump. For docs and maintenance commits, leave `VERSION` unchanged.
- Use UTC `yymmddc` for the build suffix. The daily counter runs `1`–`9`, then `a`–`z`; reset it on a new UTC day and reject exhaustion. Derive the next counter from committed history, including existing `Alfazen-Build:` trailers during a migration. Do not reuse a build ID after the clock date changes or a commit is amended.
- Prefix the first commit subject with `v<m.n.p>+<yymmddc> `, followed by the original type and text. Strip one existing matching prefix before stamping, so amend, cherry-pick, and repeated hook execution do not duplicate it. Preserve the commit body and unrelated trailers. If a repository already uses `Alfazen-Build:`, retain it and keep its value equal to the prefix.
- Validate a feature's staged `VERSION` against `HEAD:VERSION`, ignoring the prefix when reading the commit type. A local hook helps prevent mistakes but can be bypassed; use CI or server enforcement only if requested.

## Apply to a repository

Inspect its current history, hook path, version rules, and documentation first. Adapt its existing version helper and `prepare-commit-msg` hook when present; avoid installing competing hooks or replacing unrelated hook behavior. Keep hook files executable and use LF line endings. Document the policy and any required `git config core.hooksPath .githooks` setup.

Check a normal commit, a feature without a patch bump (must fail), a feature with a patch bump, and repeated stamping of an already prefixed message. Verify the resulting subject and build identifier from `git log`. Do not rewrite published history merely to prefix older commits.
