# Change log

Every change: what was done, why, and how to undo it.

## 2026-11-13 18:25 | chore: repo layout, gitignore, changelog, helper scripts
- Files changed:
  - .gitattributes
  - .github/
  - .gitignore
  - .vscode/
  - docs/
  - scripts/
- Why: Track every change in Git with a change note from day one
- Undo: Delete the added files. No cloud change.

## 2026-11-14 12:31 | audit: baseline security review and before evidence
- Files changed:
  - docs/findings.md
- Why: Record the insecure starting state as proof for the bank review
- Undo: Phase 13 removes legacy-deployer, its key, legacy-api, and the default network. Delete evidence/before to remove the files.
