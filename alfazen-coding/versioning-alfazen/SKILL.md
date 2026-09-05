---
name: versioning-alfazen
description: Default versioning protocol for Alfazen projects. Use automatically when establishing, auditing, or managing project versioning, SemVer 2.0.0, and automated Git hooks with the signature connected version+build prefix (e.g. v0.6.0+2609041).
---

# Alfazen Versioning (Connected Prefix Standard)

The signature versioning standard for Alfazen projects and applications. Combines **Semantic Versioning (SemVer 2.0.0)** with Alfazen's high-traceability **connected version+build subject prefix**, automated Git hooks, and zero-effort visual history auditing.

---

## 1. The Version Contract

### 1.1 The Connected Identifier (`v<m.n.p>+<yymmddc>`)
- Stored directly in a tracked root `VERSION` file as `v<m.n.p>+<yymmddc>` (e.g., `v0.6.0+2609041`).
- **Base SemVer (`m.n.p`)**: Standard Semantic Versioning (e.g., `0.6.0`, `1.0.0`).
- **Build Delimiter (`+`)**: Complies strictly with SemVer 2.0.0 (Rule #10) build metadata. Package managers (PyPI, npm, Go proxy, Cargo) treat `0.6.0+2609041` as fully compatible with `0.6.0`.
- **Daily Build Suffix (`yymmddc`)**: Exactly 7 characters:
  - 6 UTC date digits: `YYMMDD` (e.g., `260904` for September 4, 2026 UTC).
  - 1 daily sequence counter `c`: rolls `1` through `9`, then `a` through `z`.
  - Resets to `1` when the UTC calendar date advances.

### 1.2 Routine Commit vs. Milestone Lifecycle

Alfazen Versioning enforces standard **Semantic Versioning (SemVer 2.0.0)** synchronized with **Conventional Commits**:

| Commit Type | Semantic Level | SemVer Action | Example Transition |
| :--- | :--- | :--- | :--- |
| `feat!:` / `fix!:` / `BREAKING CHANGE:` | **Major (`m`)** | **REQUIRES EXPLICIT USER APPROVAL** $\implies$ Increment `m`, reset `n=0, p=0` | `v2.8.1+2609051` $\to$ `v3.0.0+2609052` |
| `feat:` / `feat(...):` | **Minor (`n`)** | Automated $\implies$ Increment `n`, reset `p=0` | `v2.1.0+2609051` $\to$ `v2.2.0+2609052` |
| `fix:` / `fix(...):` / `perf:` | **Patch (`p`)** | Automated $\implies$ Increment `p` | `v2.2.0+2609052` $\to$ `v2.2.1+2609053` |
| `docs:` / `chore:` / `style:` / `refactor:` / `test:` | **Build-only** | Automated $\implies$ Keep `m.n.p`, roll build counter | `v2.2.1+2609053` $\to$ `v2.2.1+2609054` |

> [!CAUTION]
> ### MANDATORY ADVISORY & APPROVAL GATE FOR MAJOR (`m`) INCREMENTS
> **Automatic incrementing of the Major version (`m`) is strictly prohibited.**
> Because bumping `m` signifies a massive milestone, breaking public API contracts, or fundamental architectural transitions, the system must never make this decision unilaterally.
>
> **The Advisory & Confirmation Protocol:**
> 1. **System Detection**: When the agent or automated pipeline senses that current changes warrant a Major increment (e.g. breaking API changes, core architecture rewrites, or fundamental paradigm shifts):
> 2. **Explicit Advisory to Project Owner**: The system **MUST explicitly advise the project owner/user**, presenting:
>    - **Rationale**: What breaking changes or major milestones justify advancing `m`.
>    - **Proposed Version**: The exact version transition (e.g. `v2.8.1` $\to$ `v3.0.0`).
>    - **Call to Action**: Explicitly ask the project owner for permission to increment `m`.
> 3. **Strict Gate Execution**:
>    - **Approved**: Only upon receiving the owner's explicit written approval may `m` be incremented (`m+1.0.0`).
>    - **Unapproved / Pending**: If approval is not explicitly granted, the system MUST stay within the current major series, staging the changes as a Minor (`n`) feature increment.

#### Rules for Coding Agents & Automation
- **Never let `m.n.p` stagnate**: When adding new user-facing features or fixing bugs, the agent/developer MUST advance `n` (for `feat`) or `p` (for `fix`) alongside the daily build counter.
- **Advise Owner on `m`**: When a major version increment is warranted, always advise the project owner first and wait for explicit confirmation. Never bump `m` autonomously.
- **Milestone & Sprint Calibration**: If multiple rapid commits occur within a feature sprint, each distinct functional capability increments `n` or `p` to guarantee high-fidelity auditability.

---

## 2. Git & Commit Integration

### 2.1 The Connected Subject Prefix
Every commit subject is automatically stamped by Git hooks:
```text
v0.6.0+2609041 feat!: rebrand project from patchtroy to Playtrafi
v0.6.0+2609042 chore(release): bump version to 0.6.0 for rebranding
v0.6.0+2609043 docs: update rebranding guide phase tracker
v0.6.0+2609044 docs: complete Phase 8 in rebranding guide
v0.6.0+2609045 ci(release): add skip-existing flag to PyPI publish step
```

### 2.2 Why Prefixing? (The Engineering Value)
- **Instant Visual Auditability:** Inspecting `git log --oneline`, `git blame`, GitHub commit lists, or CI job notifications immediately reveals the exact build without running custom queries or parsing footers.
- **Production & Issue Traceability:** Bug reports, Docker image tags, and Sentry alerts referencing a commit or build are immediately matched to the exact day and commit sequence.
- **Idempotent by Design:** The `prepare-commit-msg` hook strips any existing matching prefix first, so amends, rebases, and cherry-picks never duplicate prefixes.

---

## 3. Automated Git Hooks Setup

Place these two scripts under `.githooks/` and activate with `git config core.hooksPath .githooks`:

### `.githooks/versionlib.sh`
```sh
#!/bin/sh
VERSION_FILE=VERSION
IDENT_RE='^v[0-9]+\.[0-9]+\.[0-9]+[+-][0-9]{6}[0-9a-z]$'

die() { echo "alfazen-versioning: $*" >&2; exit 1; }
utc_yymmdd() { TZ=UTC LC_ALL=C date -u +%y%m%d; }

read_version() {
  [ -f "$VERSION_FILE" ] || die "root $VERSION_FILE file is missing"
  id=$(tr -d '\r\n\t ' < "$VERSION_FILE")
  [ -n "$id" ] || die "$VERSION_FILE is empty"
  printf '%s\n' "$id"
}

validate_identifier() {
  id=$1
  printf '%s' "$id" | grep -Eq "$IDENT_RE" || die "malformed identifier '$id' in $VERSION_FILE"
  case $id in *+*) build=${id#*+} ;; *-*) build=${id#*-} ;; esac
  bdate=${build%?}
  today=$(utc_yymmdd)
  [ "$bdate" -le "$today" ] || die "future-dated BUILD in '$id'"
}

detect_bump_type() {
  msg=$1
  case "$msg" in
    *BREAKING\ CHANGE*|*!:\ *) echo "major_requires_approval" ;;
    feat:*|feat\(*\):*)        echo "minor" ;;
    fix:*|fix\(*\):*|perf:*)   echo "patch" ;;
    *)                         echo "build" ;;
  esac
}

bump_semver() {
  ver=$1; bump=$2
  raw=${ver#v}
  m=$(echo "$raw" | cut -d. -f1)
  n=$(echo "$raw" | cut -d. -f2)
  p=$(echo "$raw" | cut -d. -f3)

  case "$bump" in
    major)
      [ "${ALFAZEN_MAJOR_APPROVED:-0}" = "1" ] || die "Major version bump (m) requires explicit user approval. Set ALFAZEN_MAJOR_APPROVED=1 to proceed."
      echo "v$((m + 1)).0.0"
      ;;
    major_requires_approval)
      die "Major version bump (m) detected. Major version increments require explicit user approval. Set ALFAZEN_MAJOR_APPROVED=1 to proceed, or stage as minor/patch."
      ;;
    minor) echo "v${m}.$((n + 1)).0" ;;
    patch) echo "v${m}.${n}.$((p + 1))" ;;
    *)     echo "v${m}.${n}.${p}" ;;
  esac
}

next_identifier() {
  old=$1; today=$2; bump=${3:-build}
  case $old in *+*) ver=${old%+*}; build=${old#*+} ;; *-*) ver=${old%-*}; build=${old#*-} ;; esac
  bdate=${build%?}
  bctr=${build#??????}

  # Apply semantic bump if requested
  ver=$(bump_semver "$ver" "$bump")

  if [ "$bdate" != "$today" ]; then
    nctr=1
  else
    case $bctr in
      [1-8]) nctr=$((bctr + 1)) ;;
      9)     nctr=a ;;
      [a-y]) nctr=$(printf '%s' "$bctr" | tr 'a-y' 'b-z') ;;
      z)     die "daily counter exhausted for $today" ;;
      *)     die "invalid counter '$bctr'" ;;
    esac
  fi
  printf '%s+%s%s\n' "$ver" "$today" "$nctr"
}
```

### `.githooks/pre-commit`
```sh
#!/bin/sh
HOOKDIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$HOOKDIR/versionlib.sh"

old=$(read_version)
validate_identifier "$old"
new=$(next_identifier "$old" "$(utc_yymmdd)") || exit 1

printf '%s\n' "$new" > "$VERSION_FILE"
git add -- "$VERSION_FILE"
```

### `.githooks/prepare-commit-msg`
```sh
#!/bin/sh
HOOKDIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$HOOKDIR/versionlib.sh"

msgfile=$1
[ -f "$msgfile" ] || exit 0
ver=$(read_version) || exit 1
validate_identifier "$ver"

tmp=$(mktemp) || exit 1
awk -v stamp="$ver" '
  !done && $0 !~ /^#/ {
    sub(/^v[0-9]+\.[0-9]+\.[0-9]+[+-][0-9][0-9][0-9][0-9][0-9][0-9][0-9a-z] /, "")
    print stamp " " $0
    done = 1
    next
  }
  { print }
' "$msgfile" > "$tmp" && mv -f -- "$tmp" "$msgfile"
```

---

## 4. Multi-Language Application Stamping

### Python (`pyproject.toml` & Package Init)
```toml
[project]
name = "myproject"
version = "0.6.0"
```
```python
import importlib.metadata
__version__ = "0.6.0"  # or read via importlib.metadata.version("myproject")
```

### Go Projects
```sh
go build -ldflags "-X main.version=$(tr -d '\r\n' < VERSION) -X main.commit=$(GIT_SHA) -X main.date=$(BUILD_DATE)"
```
