output "repository_url" {
  value = var.repository.create ? argocd_repository.repository[0].repo : var.repository.url
}
