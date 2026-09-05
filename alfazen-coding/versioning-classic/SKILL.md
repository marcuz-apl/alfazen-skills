---
name: versioning-classic
description: Strict Conventional Commits standard with Git trailers (Alfazen-Build). Use ONLY when the user explicitly requests "classic versioning", "trailer mode", or "unprefixed commit messages" for external third-party CI tools.
---

# Classic Versioning (SemVer 2.0.0 & Git Trailers)

A clean Git versioning standard for repositories that strictly require unadorned **Conventional Commits** (e.g., standard `commitlint`, automated semantic-release, or external open-source contributors), pairing clean subjects with **Git trailers** for Alfazen UTC build traceability.

---

## 1. The Version Contract

### 1.1 Base Semantic Version (`m.n.p`) & Conventional Semantic Bumping
- Stored in a tracked root `VERSION` file as pure `m.n.p` (e.g., `0.1.0`, `1.0.0`).
- **Unbounded SemVer Rules**:
  - `m`, `n`, and `p` are non-negative decimal integers (`0.1.0` → `0.1.9` → `0.1.10`). Never clamp to single digits.

Alfazen Classic Versioning enforces standard **Semantic Versioning (SemVer 2.0.0)** synchronized with **Conventional Commits**:

| Commit Type | Semantic Level | SemVer Action | Example Transition |
| :--- | :--- | :--- | :--- |
| `feat!:` / `fix!:` / `BREAKING CHANGE:` | **Major (`m`)** | **REQUIRES EXPLICIT USER APPROVAL** $\implies$ Increment `m`, reset `n=0, p=0` | `1.4.2` $\to$ `2.0.0` |
| `feat:` / `feat(...):` | **Minor (`n`)** | Automated $\implies$ Increment `n`, reset `p=0` | `1.4.2` $\to$ `1.5.0` |
| `fix:` / `fix(...):` / `perf:` | **Patch (`p`)** | Automated $\implies$ Increment `p` | `1.4.2` $\to$ `1.4.3` |
| `docs:` / `chore:` / `style:` / `refactor:` / `test:` | **Build-only** | Automated $\implies$ Keep `m.n.p`, roll build counter | `1.4.3` (trailer advances) |

> [!CAUTION]
> ### MANDATORY ADVISORY & APPROVAL GATE FOR MAJOR (`m`) INCREMENTS
> **Automatic incrementing of the Major version (`m`) is strictly prohibited.**
> Because bumping `m` signifies a massive milestone, breaking public API contracts, or fundamental architectural transitions, the system must never make this decision unilaterally.
>
> **The Advisory & Confirmation Protocol:**
> 1. **System Detection**: When the agent or automated pipeline senses that current changes warrant a Major increment (e.g. breaking API changes, core architecture rewrites, or fundamental paradigm shifts):
> 2. **Explicit Advisory to Project Owner**: The system **MUST explicitly advise the project owner/user**, presenting:
>    - **Rationale**: What breaking changes or major milestones justify advancing `m`.
>    - **Proposed Version**: The exact version transition (e.g. `1.4.3` $\to$ `2.0.0`).
>    - **Call to Action**: Explicitly ask the project owner for permission to increment `m`.
> 3. **Strict Gate Execution**:
>    - **Approved**: Only upon receiving the owner's explicit written approval may `m` be incremented (`m+1.0.0`).
>    - **Unapproved / Pending**: If approval is not explicitly granted, the system MUST stay within the current major series, staging the changes as a Minor (`n`) feature increment.

#### Rules for Coding Agents & Automation
- **Never let `m.n.p` stagnate**: When adding new user-facing features or fixing bugs, the agent/developer MUST advance `n` in `VERSION` (for `feat`) or `p` (for `fix`) alongside the daily build counter.
- **Advise Owner on `m`**: When a major version increment is warranted, always advise the project owner first and wait for explicit confirmation. Never bump `m` autonomously.
- **Milestone & Sprint Calibration**: If multiple rapid commits occur within a feature sprint, each distinct functional capability increments `n` or `p` to guarantee high-fidelity auditability.

### 1.2 Alfazen Build Identifier (`+yymmddc`)
- Formatted as SemVer **build metadata** using the `+` delimiter: `v<m.n.p>+<yymmddc>` (e.g., `v1.0.0+2609041`).
- The `yymmddc` suffix is exactly 7 characters:
  - 6 UTC date digits: `YYMMDD` (e.g., `260904` for 2026-09-04 UTC).
  - 1 daily sequence counter `c`: rolls `1` through `9`, then `a` through `z`.
  - Resets to `1` when the UTC calendar date advances.
- **Package Manager Compliance**: Under SemVer 2.0.0 (Rule #10), build metadata is ignored for version precedence. Package managers (PyPI, npm, Go proxy, Cargo) treat `1.0.0+2609041` as fully compatible with `1.0.0`.

---

## 2. Git & Commit Integration

### 2.1 Commit Message Subject (Row 1)
- The first line must be a pure **Conventional Commit** without version prefixes:
  ```text
  feat: add markdown converter
  fix: handle nil pointer in browser lease
  ```
- **Rationale**: 100% compatible with off-the-shelf tooling (`commitlint`, `standard-version`, automated changelogs) without requiring custom regex.

### 2.2 Commit Trailer (Git Footer)
- Place the build identifier in a standard Git trailer at the end of the commit message:
  ```text
  feat: add markdown converter

  Alfazen-Build: v1.0.0+2609041
  ```
- Automated via `.githooks/prepare-commit-msg`.
- Inspectable using standard Git commands:
  ```sh
  git log --format="%(trailers:key=Alfazen-Build)"
  ```

---

## 3. Application & CLI Runtime Stamping

Binaries and libraries report their full build identifier when invoked with `--version` or `-v`:

```text
<app> version v1.0.0+2609041 (commit 9a3b1de, built 2026-09-04T10:00:00Z)
```

### Go Projects
```sh
go build -ldflags "-X main.version=v$(./.githooks/alfazen-version id) -X main.commit=$(GIT_SHA) -X main.date=$(BUILD_DATE)" -o bin/<app> ./cmd/<app>
```

### Python Projects
Standardize package version in `pyproject.toml` (`version = "1.0.0"`) and read build info dynamically via `importlib.metadata`.

---

## 4. Repository Configuration Checklist

1. **Root `VERSION` File**: Contains the base semantic version (e.g. `1.0.0`).
2. **Unified Version Engine (`.githooks/alfazen-version`)**: Single source of truth for computing build identifiers and stamping trailers:
   - `alfazen-version id` -> prints `1.0.0+2609041`
   - `alfazen-version hook "$@"` -> stamps `Alfazen-Build:` trailer on commit messages.
3. **Git Hook Entrypoint (`.githooks/prepare-commit-msg`)**:
   ```sh
   #!/bin/sh
   exec "$(dirname "$0")/alfazen-version" hook "$@"
   ```
4. **Hook Activation**:
   ```sh
   git config core.hooksPath .githooks
   ```
