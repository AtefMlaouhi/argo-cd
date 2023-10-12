provider "gitlab" {
  token    = var.gitlab_token
  base_url = "https://git.harvest.fr/api/v4"
}

provider "argocd" {
  server_addr      = var.argocd_hosts.dev
  alias            = "dev"
  use_local_config = true
  context          = var.argocd_hosts.dev
}

provider "argocd" {
  server_addr      = var.argocd_hosts.dev_flex
  alias            = "dev-flex"
  use_local_config = true
  context          = var.argocd_hosts.dev_flex
}

provider "argocd" {
  server_addr      = var.argocd_hosts.preprod
  alias            = "preprod"
  use_local_config = true
  context          = var.argocd_hosts.preprod
}

provider "argocd" {
  server_addr      = var.argocd_hosts.prod
  alias            = "prod"
  use_local_config = true
  context          = var.argocd_hosts.prod
}

provider "argocd" {
  server_addr      = var.argocd_hosts.prod_flex
  alias            = "prod-flex"
  use_local_config = true
  context          = var.argocd_hosts.prod_flex
}

locals {
  argocd_all_hosts = [
    var.argocd_hosts.dev,
    var.argocd_hosts.preprod,
    var.argocd_hosts.prod,
    var.argocd_hosts.dev_flex,
    var.argocd_hosts.prod_flex
  ]
  argocd_hosts = [
    var.argocd_hosts.dev,
    var.argocd_hosts.preprod,
    var.argocd_hosts.prod,
  ]
  argocd_flex_hosts = [
    var.argocd_hosts.dev_flex,
    var.argocd_hosts.prod_flex
  ]
}
