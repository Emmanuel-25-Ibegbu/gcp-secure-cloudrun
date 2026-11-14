output "wif_provider" {
  value = google_iam_workload_identity_pool_provider.github.name
}

output "deployer_email" {
  value = google_service_account.deployer.email
}

output "runtime_email" {
  value = google_service_account.api_runtime.email
}
