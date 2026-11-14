# Org-level guardrails. Need a GCP Organization.
# Off by default. Set enable_org_policies = true after moving the project into the Organization.

resource "google_project_organization_policy" "no_vm_external_ip" {
  count      = var.enable_org_policies ? 1 : 0
  project    = var.project_id
  constraint = "compute.vmExternalIpAccess"

  list_policy {
    deny {
      all = true
    }
  }
}

resource "google_project_organization_policy" "no_sa_keys" {
  count      = var.enable_org_policies ? 1 : 0
  project    = var.project_id
  constraint = "iam.disableServiceAccountKeyCreation"

  boolean_policy {
    enforced = true
  }
}
