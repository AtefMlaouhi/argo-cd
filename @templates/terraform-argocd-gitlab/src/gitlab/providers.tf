terraform {
  required_providers {
    argocd = {
      source  = "oboukili/argocd"
      version = "4.3.0"
    }
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "3.16.0"
    }
  }
}
