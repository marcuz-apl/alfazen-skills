#!/usr/bin/env bash
# digest-commits.sh: Helper script for changelog synthesis
set -euo pipefail

BASE_REF="${1:-$(git describe --tags --abbrev=0 2>/dev/null || git rev-list --max-parents=0 HEAD)}"
TARGET_REF="${2:-HEAD}"

echo "=== Changelog Digest: $BASE_REF .. $TARGET_REF ==="
echo ""
echo "--- Commits Breakdown ---"
git log "$BASE_REF..$TARGET_REF" --format="* %h | %ad | %s" --date=short
echo ""
echo "--- Touched Paths Summary ---"
git diff --stat "$BASE_REF..$TARGET_REF"
