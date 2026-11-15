# Data Access audit logs for sensitive services
locals {
  data_access_services = [
    "secretmanager.googleapis.com",
    "storage.googleapis.com",
    "iamcredentials.googleapis.com",
    "sts.googleapis.com",
  ]
}

resource "google_project_iam_audit_config" "data_access" {
  for_each = toset(local.data_access_services)
  project  = var.project_id
  service  = each.value

  audit_log_config {
    log_type = "ADMIN_READ"
  }
  audit_log_config {
    log_type = "DATA_READ"
  }
  audit_log_config {
    log_type = "DATA_WRITE"
  }
}

# Log bucket kept 180 days
resource "google_logging_project_bucket_config" "security" {
  project        = var.project_id
  location       = "global"
  bucket_id      = "security-logs-180d"
  retention_days = 180
  description    = "Audit, firewall, and VPC flow logs kept 180 days for the partner bank review"
}

# Route security logs into it
resource "google_logging_project_sink" "security" {
  name        = "security-logs-to-180d"
  destination = "logging.googleapis.com/${google_logging_project_bucket_config.security.id}"

  filter = <<-EOT
    logName:"cloudaudit.googleapis.com"
    OR logName:"compute.googleapis.com%2Fvpc_flows"
    OR logName:"compute.googleapis.com%2Ffirewall"
  EOT

  unique_writer_identity = true
}
