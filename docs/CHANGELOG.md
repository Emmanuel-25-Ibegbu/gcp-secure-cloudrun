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

## 2026-11-14 13:51 | feat(terraform): state backend, providers, enabled APIs
- Files changed:
  - terraform/
- Why: Infrastructure is code, reviewed and repeatable
- Undo: Run terraform destroy. Delete the state bucket with gcloud storage rm -r gs://PROJECT_ID-tfstate. APIs stay on by design.

## 2026-11-14 15:28 | feat(terraform): network, firewall, and org policies behind a switch (not applied yet)
- Files changed:
  - terraform/terraform.tfvars.example
  - terraform/variables.tf
  - --location=us-central1
  - --public-access-prevention
  - --uniform-bucket-level-access
  - terraform/firewall.tf
  - terraform/network.tf
  - terraform/org-policy.tf
- Why: Network isolation and guardrail code ready for when the GCP trial is active
- Undo: git revert this commit. No cloud change.

## 2026-11-14 16:11 | feat(iam): service accounts, keyless GitHub login, outputs (not applied yet)
- Files changed:
  - terraform/iam.tf
  - terraform/outputs.tf
  - terraform/wif.tf
- Why: Least-privilege identities and keyless CI/CD code ready for when the GCP trial is active
- Undo: git revert this commit. No cloud change.

## 2026-11-14 16:31 | feat: Artifact Registry, Secret Manager secret, versioned data bucket, not applied yet
- Files changed:
  - terraform/registry.tf
  - terraform/secrets.tf
  - terraform/storage.tf
- Why: Trusted image store, no plain-text secrets, recoverable data
- Undo: git revert this commit. No cloud change yet.

## 2026-11-15 15:39 | feat(app): Flask API with health, status, and gated fault routes
- Files changed:
  - app/
- Why: A small API to deploy and test the pipeline and alerts
- Undo: Revert this commit with git revert. No cloud change.

## 2026-11-15 16:05 | feat(cloudrun): secure-api service with Secret Manager env and VPC egress, not applied yet
- Files changed:
  - terraform/cloudrun.tf
- Why: Managed runtime with a dedicated identity and no plain-text secrets
- Undo: it revert this commit. No cloud change yet.

## 2026-11-15 16:09 | docs: remove doubled labels in change log
- Files changed:
  - docs/CHANGELOG.md
- Why: Change log entries had repeated labels
- Undo: git revert this commit

## 2026-11-15 16:40 | ci: add deploy pipeline (disabled until GCP is ready) and Terraform checks
- Files changed:
  - .github/workflows/deploy.yml.disabled
  - .github/workflows/terraform-checks.yml
- Why: Pipeline code ready before cloud access
- Undo: git revert this commit. No cloud change.

## 2026-11-15 18:54 | feat(logging): data access audit logs, 180-day security log bucket and sink, not applied yet
- Files changed:
  - terraform/logging.tf
- Why: Audit trail kept 180 days for the bank review
- Undo: git revert this commit. No cloud change yet.

## 2026-11-15 19:06 | feat(monitoring): uptime check and Slack alerts for downtime, errors, latency, not applied yet
- Files changed:
  - terraform/monitoring.tf
- Why: The team learns about problems before customers do
- Undo: git revert this commit. No cloud change yet.

## 2026-11-16 14:01 | docs: restore test template, test not run yet
- Files changed:
  - docs/restore-test.md
- Why: Ready to record steps, timing, and proof when the test runs
- Undo: git revert this commit. No cloud change.

## 2026-11-16 15:16 | docs: evidence pack, architecture, runbook, README, weekly update template
- Files changed:
  - README.md
  - docs/architecture.md
  - docs/evidence-pack.md
  - docs/runbook.md
  - docs/week-01.md
- Why: Hand over everything the team and auditors need
- Undo: Revert this commit with git revert. No cloud change.

## 2026-11-16 15:20 | docs: evidence pack, architecture, runbook, README, weekly update template
- Files changed:
  - docs/evidence-pack.md
- Why: Hand over everything the team and auditors need
- Undo: Revert this commit with git revert. No cloud change.
