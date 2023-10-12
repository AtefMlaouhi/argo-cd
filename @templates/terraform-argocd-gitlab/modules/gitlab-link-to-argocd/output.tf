output "read_token" {
  value = {
    login = gitlab_project_access_token.argocd-read.name
    value = gitlab_project_access_token.argocd-read.token
  }
  sensitive = true
}
