#!/bin/bash
# validate.sh — smoke test for the hardshell skill
# Verifies SKILL.md is present, parseable, and that no legacy CLAUDE.md exists.

set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

echo "🔍 Validating hardshell skill..."

# 1. SKILL.md exists and has required fields
if [ ! -f SKILL.md ]; then
  echo "❌ SKILL.md not found"
  exit 1
fi

NAME=$(grep -m1 '^name:' SKILL.md | sed 's/^name:[[:space:]]*//')
VERSION=$(grep -m1 '^version:' SKILL.md | sed 's/^version:[[:space:]]*//')

if [ -z "$NAME" ] || [ -z "$VERSION" ]; then
  echo "❌ SKILL.md missing name or version"
  exit 1
fi
echo "  ✅ SKILL.md: name=$NAME version=$VERSION"

# 2. No legacy CLAUDE.md
if [ -f CLAUDE.md ]; then
  echo "❌ Legacy CLAUDE.md found — conventions should live in SKILL.md"
  exit 1
fi
echo "  ✅ No legacy CLAUDE.md"

# 3. No .claude/ directory tracked by git
if git ls-files .claude/ | grep -q . 2>/dev/null; then
  echo "❌ .claude/ directory is tracked by git — should be gitignored"
  exit 1
fi
echo "  ✅ .claude/ not tracked"

# 4. All reference files exist
REFS=("references/git-workflow.md" "references/performance.md" "references/testing.md" "references/skill-development.md" "references/languages/python.md" "references/languages/typescript.md" "references/languages/go.md")
for ref in "${REFS[@]}"; do
  if [ ! -f "$ref" ]; then
    echo "❌ Missing reference: $ref"
    exit 1
  fi
done
echo "  ✅ All reference files present (${#REFS[@]})"

# 5. No 'Claude' mentions in tracked files (case-insensitive)
if git grep -qi 'claude' -- "$(git ls-files)" 2>/dev/null; then
  echo "⚠️  Found 'Claude' mentions in tracked files (review if intentional):"
  git grep -in 'claude' -- "$(git ls-files)" 2>/dev/null || true
else
  echo "  ✅ No 'Claude' mentions in tracked files"
fi

echo ""
echo "✅ All validations passed — $NAME v$VERSION is clean"