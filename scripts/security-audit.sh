#!/usr/bin/env bash
# Security audit. Writes read-only results to a folder.
# Usage: ./scripts/security-audit.sh PROJECT_ID REGION OUTPUT_DIR
set -euo pipefail
PROJECT_ID="${1:?project id}"
REGION="${2:?region}"
OUT="${3:?output dir}"
mkdir -p "$OUT"

# On Windows, Git Bash must use gcloud.cmd (the plain gcloud needs a separate Python)
if command -v gcloud.cmd >/dev/null 2>&1; then
  gcloud() { gcloud.cmd "$@"; }
fi

echo "Audit of $PROJECT_ID at $(date -u +%Y-%m-%dT%H:%M:%SZ)" > "$OUT/00-run-info.txt"

# 1. Networks and firewall rules
gcloud compute networks list --project "$PROJECT_ID" > "$OUT/01-networks.txt"
gcloud compute firewall-rules list --project "$PROJECT_ID" \
  --format="table(name,network,direction,priority,sourceRanges.list(),allowed[].map().firewall_rule().list(),denied[].map().firewall_rule().list(),disabled)" \
  > "$OUT/02-firewall-rules.txt"
gcloud compute firewall-rules list --project "$PROJECT_ID" \
  --filter="direction=INGRESS AND sourceRanges:0.0.0.0/0 AND allowed:*" \
  --format="table(name,network,allowed[].map().firewall_rule().list())" \
  > "$OUT/03-open-ingress-rules.txt"

# 2. Public IPs
gcloud compute instances list --project "$PROJECT_ID" \
  --format="table(name,zone,networkInterfaces[].accessConfigs[].natIP.list())" > "$OUT/04-vm-public-ips.txt"
gcloud compute addresses list --project "$PROJECT_ID" > "$OUT/05-reserved-addresses.txt"

# 3. IAM
gcloud projects get-iam-policy "$PROJECT_ID" --format=json > "$OUT/06-iam-policy.json"
gcloud projects get-iam-policy "$PROJECT_ID" --flatten="bindings[].members" \
  --filter="bindings.role:(roles/owner roles/editor)" \
  --format="table(bindings.role,bindings.members)" > "$OUT/07-broad-roles.txt"

# 4. Service accounts and user-managed keys
gcloud iam service-accounts list --project "$PROJECT_ID" > "$OUT/08-service-accounts.txt"
: > "$OUT/09-user-managed-keys.txt"
for sa in $(gcloud iam service-accounts list --project "$PROJECT_ID" --format="value(email)"); do
  echo "== $sa" >> "$OUT/09-user-managed-keys.txt"
  gcloud iam service-accounts keys list --iam-account "$sa" --managed-by=user \
    --format="table(name.basename(),validAfterTime)" >> "$OUT/09-user-managed-keys.txt"
done

# 5. Cloud Run: plain-text env vars vs Secret Manager (values never printed)
: > "$OUT/10-cloudrun-env-sources.txt"
for svc in $(gcloud run services list --project "$PROJECT_ID" --region "$REGION" --format="value(metadata.name)"); do
  echo "== $svc" >> "$OUT/10-cloudrun-env-sources.txt"
  gcloud run services describe "$svc" --project "$PROJECT_ID" --region "$REGION" --format=json \
    | jq -r '.spec.template.spec.containers[0].env[]? | "\(.name)\t\(if .valueFrom then "SECRET_MANAGER" else "PLAINTEXT" end)"' \
    >> "$OUT/10-cloudrun-env-sources.txt"
  gcloud run services describe "$svc" --project "$PROJECT_ID" --region "$REGION" \
    --format="value(spec.template.spec.serviceAccountName)" | sed 's/^/runtime SA: /' >> "$OUT/10-cloudrun-env-sources.txt"
done

# 6. Buckets
gcloud storage buckets list --project "$PROJECT_ID" \
  --format="table(name,iamConfiguration.publicAccessPrevention,versioning.enabled)" > "$OUT/11-buckets.txt"

# 7. Logging
gcloud logging buckets list --project "$PROJECT_ID" > "$OUT/12-log-buckets.txt"
gcloud logging sinks list --project "$PROJECT_ID" > "$OUT/13-log-sinks.txt"

echo "Done. Results in $OUT"
