#!/usr/bin/env bash
# Saves your work to GitHub with a change note.
# Usage:
#   ./scripts/checkpoint.sh 05-network   uses the ready answers for that step
#   ./scripts/checkpoint.sh              asks you the 3 questions yourself
set -euo pipefail
ROOT=$(git rev-parse --show-toplevel)
cd "$ROOT"

if [ -z "$(git status --porcelain)" ]; then
  echo "Nothing to save."
  exit 0
fi

STEP="${1:-}"
MSG=""
WHY=""
UNDO=""

if [ -n "$STEP" ]; then
  LINE=$(grep -m1 "^${STEP}|" scripts/checkpoints.txt || true)
  if [ -z "$LINE" ]; then
    echo "No ready answers for '$STEP'. Valid step names:"
    grep -v -e '^#' -e '^$' scripts/checkpoints.txt | cut -d'|' -f1
    exit 1
  fi
  IFS='|' read -r _ MSG WHY UNDO <<< "$LINE"
  UNDO="${UNDO%$'\r'}"
  echo ""
  echo "Commit message: $MSG"
  echo "Why:            $WHY"
  echo "How to undo:    $UNDO"
  echo ""
  read -r -p "Use these? (yes/no): " ok
  if [ "$ok" != "yes" ]; then
    MSG=""
  fi
fi

if [ -z "$MSG" ]; then
  read -r -p "Commit message: " MSG
  read -r -p "Why: " WHY
  read -r -p "How to undo: " UNDO
fi

CHANGED=$(git status --porcelain | cut -c4- | sed 's/^/  - /')

{
  echo ""
  echo "## $(date '+%Y-%m-%d %H:%M') | $MSG"
  echo "- Files changed:"
  echo "$CHANGED"
  echo "- Why: $WHY"
  echo "- Undo: $UNDO"
} >> docs/CHANGELOG.md

git add -A

# Safety net: never push state, tfvars, keys, or .env
BLOCKED=$(git diff --cached --name-only | grep -E '\.tfstate|\.tfvars$|key.*\.json$|(^|/)\.env$' || true)
if [ -n "$BLOCKED" ]; then
  echo "Stopped. These files must never be pushed:"
  echo "$BLOCKED"
  git reset -q
  exit 1
fi

git commit -q -m "$MSG" -m "Why: $WHY" -m "Undo: $UNDO"

# Always work on a branch called main
if [ "$(git branch --show-current)" != "main" ]; then
  git branch -M main
fi

# Pull first only if GitHub already has a main branch (not true on the first push)
if git ls-remote --exit-code --heads origin main >/dev/null 2>&1; then
  git pull --rebase -q origin main
fi
git push -q -u origin main
echo "Pushed: $(git log -1 --oneline)"
