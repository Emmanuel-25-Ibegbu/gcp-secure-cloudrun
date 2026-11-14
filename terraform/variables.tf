variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "github_repo" {
  type        = string
  description = "GitHub repo allowed to deploy, in owner/name format"
}

variable "enable_org_policies" {
  type        = bool
  default     = false
  description = "Turn on only when the project sits inside a GCP Organization"
}
