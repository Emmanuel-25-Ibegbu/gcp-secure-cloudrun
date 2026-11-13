#!/usr/bin/env bash
# Checks, previews, saves evidence, and applies Terraform.
# Usage: ./scripts/tf.sh 05-network
set -euo pipefail
NAME="${1:?usage: tf.sh <step-name>, for example 05-network}"
ROOT=$(git rev-parse --show-toplevel)
cd "$ROOT/terraform"
mkdir -p ../evidence/plans

terraform fmt -recursive
terraform validate
terraform plan -out tfplan -input=false
terraform show -no-color tfplan > "../evidence/plans/${NAME}.txt"

read -r -p "Apply this plan? (yes/no): " ok
if [ "$ok" != "yes" ]; then
  echo "Stopped. Nothing applied."
  rm -f tfplan
  exit 0
fi

terraform apply tfplan
terraform output -no-color > "../evidence/plans/${NAME}-outputs.txt" 2>/dev/null || true
rm -f tfplan
echo "Applied. Plan saved to evidence/plans/${NAME}.txt"
