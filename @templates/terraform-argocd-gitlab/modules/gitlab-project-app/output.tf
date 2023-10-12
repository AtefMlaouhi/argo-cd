output "project_id" {
  value = gitlab_project.project.id
}

output "read_token" {
  value = {
    login = module.argocd-link[*].read_token.login
    value = module.argocd-link[*].read_token.value
  }
  sensitive = true
}

output "write_token" {
  value = {
    login = var.write_token_enabled ? gitlab_project_access_token.gitlab-cd-push[0].name : ""
    value = var.write_token_enabled ? gitlab_project_access_token.gitlab-cd-push[0].token : ""
  }
  sensitive = true
}

output "http_url_to_repo" {
  value = gitlab_project.project.http_url_to_repo
}
