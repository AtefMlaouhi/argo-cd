variable "project_id" {
  type        = number
  description = "Gitlab project ID"
}

variable "argocd_hosts" {
  type = list(string)
}

variable "is_legacy_token" {
  type    = bool
  default = false
}
