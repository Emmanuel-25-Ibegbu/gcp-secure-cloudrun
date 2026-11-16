# Secure Cloud Run on GCP: audit-ready rebuild

Terraform rebuild of a customer-facing API on Google Cloud, hardened for a partner bank security review.

## What it includes
- Terraform for APIs, custom VPC, deny-by-default firewall, IAM, Artifact Registry, Secret Manager, Cloud Run, logging, monitoring
- Keyless CI/CD: GitHub Actions to Cloud Run through Workload Identity Federation
- Secrets in Secret Manager, no service-account keys
- Audit logs, VPC flow logs, 180-day log bucket
- Uptime check and Slack alerts for downtime, errors, latency
- Misconfiguration review with before and after proof
- Timed restore test
- Evidence pack, architecture diagram, runbook

## Layout
app/ API code and Dockerfile
terraform/ infrastructure
.github/workflows/ CI/CD
scripts/ Terraform helper, save-to-GitHub script, security audit script
docs/ evidence pack, findings, runbook, restore test, change log
evidence/ before and after outputs, plans, screenshots

## Quick start
1. gcloud auth login and gcloud auth application-default login
2. Create the state bucket (docs/GCP-BUILD-GUIDE.md, Phase 4)
3. cp terraform/terraform.tfvars.example terraform/terraform.tfvars and fill it in
4. cd terraform && terraform init && terraform apply
5. Set the four GitHub Actions variables from terraform output
6. Push to main to deploy

## Docs
- docs/evidence-pack.md
- docs/architecture.md
- docs/runbook.md
- docs/findings.md
- docs/restore-test.md
- docs/CHANGELOG.md
