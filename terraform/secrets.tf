resource "google_secret_manager_secret" "payment_api_key" {
  secret_id = "payment-api-key"

  replication {
    auto {}
  }

  depends_on = [google_project_service.apis]
}

resource "google_secret_manager_secret_iam_member" "runtime_reads_payment_key" {
  secret_id = google_secret_manager_secret.payment_api_key.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.api_runtime.email}"
}
