resource "gitlab_project_access_token" "gitlab-cd-push" {
  count        = var.write_token_enabled ? 1 : 0
  project      = gitlab_project.project.id
  name         = format("REPO_%s-write", var.project_name)
  scopes       = ["api", "write_repository"]
}
