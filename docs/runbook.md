# Runbook: secure-api

## Deploy
Merge or push to main. GitHub Actions builds, pushes, and deploys. Manual run: Actions > Build and deploy secure-api > Run workflow.

## Roll back a bad release
```bash
gcloud run revisions list --service secure-api --region us-central1
gcloud run services update-traffic secure-api --region us-central1 --to-revisions REVISION_NAME=100
```
Back to normal: push a fix, or run update-traffic with --to-latest.

## Rotate the payment API key
```bash
printf "NEW_VALUE" | gcloud secrets versions add payment-api-key --data-file=-
```
Run the deploy workflow so a new revision picks up "latest". Check /api/v1/status. Then disable the old version:
```bash
gcloud secrets versions list payment-api-key
gcloud secrets versions disable OLD_VERSION --secret payment-api-key
```

## Respond to an alert
1. Open the Slack alert link to see the chart.
2. Logs Explorer: resource.type="cloud_run_revision" AND resource.labels.service_name="secure-api" AND severity>=ERROR
3. If a new release caused it, roll back.
4. Write what happened in docs/CHANGELOG.md.

## Restore a deleted file
See docs/restore-test.md.

## Change infrastructure
Edit terraform/ in VS Code, then in Git Bash run ./scripts/tf.sh with a short step name, then ./scripts/checkpoint.sh and answer the 3 questions.

## Give a teammate access
Grant roles to named people or Google groups. Never create a service-account key. Never grant Owner or Editor to a service account.
