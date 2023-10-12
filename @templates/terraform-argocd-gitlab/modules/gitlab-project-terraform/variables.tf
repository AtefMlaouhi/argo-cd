variable "project_path" {
  type        = string
  description = "Gitlab project url without the host (eg: O2S/o2s-modularisation/fr.harvest.geocoding)"
}

variable "project_name" {
  type        = string
  description = "Repository name (eg: fr.harvest.geocoding)"
}

variable "webhook_atlantis_enabled" {
  type    = bool
  default = true
}

variable "atlantis_host" {
  type    = string
  default = ""
}

locals {
  # tflint-ignore: terraform_unused_declarations
  validate_atlantis = (var.webhook_atlantis_enabled && var.atlantis_host == "") ? tobool("When var.webhook_atlantis_enabled is set, var.atlantis_host must also be filled.") : true
}

variable "default_branch" {
  type    = string
  default = "main"
}

variable "only_allow_merge_if_pipeline_succeeds" {
  type    = bool
  default = true
}

variable "ci_fetch_default_git_depth" {
  type    = number
  default = 0
}

variable "pipelines_enabled" {
  type    = bool
  default = true
}
