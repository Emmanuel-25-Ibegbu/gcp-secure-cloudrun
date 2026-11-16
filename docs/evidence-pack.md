# Evidence pack: secure-api on GCP

| ID | Control | How it is implemented | Proof |
|---|---|---|---|
| C01 | Infrastructure as code | All resources in terraform/, state in versioned GCS bucket | terraform/, evidence/plans/ |
| C02 | Network isolation | Custom VPC secure-vpc, app-subnet, no default network | evidence/after/01-networks.txt, screenshot |
| C03 | Deny-by-default firewall | deny-all-ingress and deny-all-egress with logging | evidence/after/02-firewall-rules.txt |
| C04 | No public IPs on internal resources | No VMs or reserved IPs, Cloud Run is the only public entry | evidence/after/04-vm-public-ips.txt, 05-reserved-addresses.txt |
| C05 | Least-privilege IAM | One SA per job, resource-level grants, no SA with Owner or Editor | terraform/iam.tf, evidence/after/07-broad-roles.txt |
| C06 | No service-account keys | Keys deleted, none exist | evidence/after/09-user-managed-keys.txt |
| C07 | Keyless CI/CD | GitHub OIDC to WIF, limited to repo and main branch | terraform/wif.tf, Actions run screenshot, STS audit logs |
| C08 | Secrets management | Secret in Secret Manager, read only by api-runtime | evidence/after/10-cloudrun-env-sources.txt, Secret Manager audit log |
| C09 | Audit logging | Admin Activity always on, Data Access on for 4 services | terraform/logging.tf, Logs Explorer screenshot |
| C10 | Network logging | VPC flow logs and firewall logs | screenshot of vpc_flows entries |
| C11 | Log retention 180 days | security-logs-180d bucket and sink | evidence/after/12-log-buckets.txt |
| C12 | Monitoring and alerting | Uptime check, 5xx and latency alerts to Slack, all tested | screenshots/alert-*.png |
| C13 | Misconfiguration review | Findings F1 to F6 fixed with before and after | docs/findings.md, evidence/before, evidence/after |
| C14 | Backup and restore | Versioned bucket with soft delete, restore tested and timed | docs/restore-test.md |
| C15 | Change management | Every change in Git with a change note and undo step | Git history, docs/CHANGELOG.md |
| C16 | Image integrity | Images tagged by commit SHA, immutable tags | terraform/registry.tf, evidence/after/artifact-images.txt |
