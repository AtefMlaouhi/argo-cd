module "argocd-link" {
  source = "../gitlab-link-to-argocd"
  count  = var.create_argocd_link ? 1 : 0

  project_id      = gitlab_project.project.id
  argocd_hosts    = var.argocd_hosts
  is_legacy_token = var.argocd_legacy_token
}
