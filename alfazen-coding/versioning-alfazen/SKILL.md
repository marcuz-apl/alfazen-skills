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
- **Routine Commits (Build Advances)**:
  - The base SemVer (`m.n.p`) **remains stable** across regular feature work, fixes, and daily commits.
  - The Git hook automatically advances only the daily counter:
    ```text
    v0.6.0+2609041 -> v0.6.0+2609042 -> v0.6.0+2609043
    ```
- **Intentional Milestone Bumps (Minor / Major Releases)**:
  - When reaching a major milestone, rebranding, or breaking API transition (e.g. `0.5.2` -> `0.6.0`), the developer or release workflow explicitly updates the baseline in `VERSION` and project manifests (`pyproject.toml`, `package.json`).
  - Subsequent commits immediately inherit and roll from the new `0.6.0` baseline.

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

next_identifier() {
  old=$1; today=$2
  case $old in *+*) ver=${old%+*}; build=${old#*+} ;; *-*) ver=${old%-*}; build=${old#*-} ;; esac
  bdate=${build%?}
  bctr=${build#??????}

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
