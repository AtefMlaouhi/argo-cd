variable "gitlab_token" {
  type        = string
  description = "Token who has access to create repository token."
  sensitive   = true
}

variable "argocd_hosts" {
  type = object({
    dev       = string
    dev_flex  = string
    preprod   = string
    prod      = string
    prod_flex = string
  })
}

variable "rancher_clusterids" {
  type = object({
    dev       = string
    dev_flex  = string
    preprod   = string
    prod      = string
    prod_flex = string
  })
}

variable "rancher_projects" {
  type = object({
    o2sm = object({
      dev     = string
      preprod = string
      prod    = string
    })
  })
}

variable "atlantis_host" {
  type    = string
  default = ""
}

variable "project_terraform" {
  type = object({
    name = string
    path = string
  })
}
