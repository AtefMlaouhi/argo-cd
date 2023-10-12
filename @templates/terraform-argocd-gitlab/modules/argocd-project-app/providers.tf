terraform {
  required_providers {
    argocd = {
      source                = "oboukili/argocd"
      version               = "4.3.0"
      configuration_aliases = [argocd.project, argocd.app]
    }
  }
}
