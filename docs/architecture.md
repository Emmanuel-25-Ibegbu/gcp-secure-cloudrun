```mermaid
flowchart LR
  dev[Developer pushes to main] --> gha[GitHub Actions]
  gha -- OIDC token --> wif[Workload Identity Federation]
  wif -- short-lived token --> dep[gh-deployer SA]
  gha -- docker push --> ar[(Artifact Registry)]
  gha -- deploy --> run[Cloud Run secure-api<br>runs as api-runtime SA]
  ar -- pull image --> run
  cust[Customers and partner bank] -- HTTPS --> run
  run -- read secret --> sm[(Secret Manager)]
  run -- read data --> gcs[(Cloud Storage app-data versioned)]
  run -- Direct VPC egress --> vpc[secure-vpc app-subnet<br>deny-all firewall, flow logs]
  run --> logs[Cloud Logging]
  sm --> logs
  vpc --> logs
  logs -- sink --> lb[(security-logs-180d)]
  mon[Cloud Monitoring<br>uptime and alerts] -- alerts --> slack[Slack alerts channel]
```
