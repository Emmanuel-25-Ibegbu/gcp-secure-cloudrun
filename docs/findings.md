# Misconfiguration review

| ID | Finding | Risk | Evidence (before) | Fix | Evidence (after) |
|---|---|---|---|---|---|
| F1 | Default VPC allows SSH and RDP from 0.0.0.0/0 | High | evidence/before/03-open-ingress-rules.txt | Delete default VPC, custom VPC with deny-all | evidence/after/03-open-ingress-rules.txt |
| F2 | legacy-deployer has roles/editor | High | evidence/before/07-broad-roles.txt | Delete SA, use per-job SAs | evidence/after/07-broad-roles.txt |
| F3 | User-managed SA key exists | High | evidence/before/09-user-managed-keys.txt | Delete key, use WIF | evidence/after/09-user-managed-keys.txt |
| F4 | Secret stored as plain env var | High | evidence/before/10-cloudrun-env-sources.txt | Move to Secret Manager | evidence/after/10-cloudrun-env-sources.txt |
| F5 | Default compute SA has roles/editor | Medium | evidence/before/07-broad-roles.txt | Remove binding | evidence/after/07-broad-roles.txt |
| F6 | Logs kept 30 days only, no flow logs | Medium | evidence/before/12-log-buckets.txt | 180-day bucket and sink, flow logs | evidence/after/12-log-buckets.txt |
