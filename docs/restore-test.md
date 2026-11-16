# Restore test

Date: 2026-11-XX
Operator: Emmanuel Ibegbu
Bucket: PROJECT_ID-app-data (versioning on, soft delete 7 days)

## Steps
1. Uploaded ledgers/ledger-test.csv. SHA-256: ...
2. Deleted it at T0.
3. Listed versions with gcloud storage ls -a and found generation ...
4. Copied that generation back to the live name at T1.
5. Downloaded and checked the hash at T2. Match: yes.

## Timing
| Step | Time (UTC) |
|---|---|
| T0 delete | ... |
| T1 restore start | ... |
| T2 restore verified | ... |
| Total time to recover | ... seconds |

## Evidence
- evidence/after/restore-timing.txt
- evidence/after/restore-hash-original.txt, restore-hash-restored.txt
- evidence/screenshots/restore-audit-log.png

## Limits
- Old versions beyond 5 per file are deleted by the lifecycle rule.
- Soft-deleted files are kept 7 days.
