resource "gitlab_project_access_token" "argocd-read" {
  project      = var.project_id
  name         = format("REPO_%s-read", data.gitlab_project.project.path)
  scopes       = ["read_repository"]
  access_level = var.is_legacy_token ? "maintainer" : "guest"
}
