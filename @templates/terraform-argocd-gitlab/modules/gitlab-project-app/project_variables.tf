resource "gitlab_project_variable" "gl-token" {
  count   = var.write_token_enabled ? 1 : 0
  project = gitlab_project.project.id
  key     = "GL_TOKEN"
  value   = gitlab_project_access_token.gitlab-cd-push[0].token
  masked  = true
}

resource "gitlab_project_variable" "write-token-login" {
  count   = var.write_token_enabled ? 1 : 0
  project = gitlab_project.project.id
  key     = "WRITE_TOKEN_LOGIN"
  value   = gitlab_project_access_token.gitlab-cd-push[0].name
}

resource "gitlab_project_variable" "semantic_config" {
  count         = var.semantic_config != "" ? 1 : 0
  project       = gitlab_project.project.id
  key           = "SEMANTIC_CONFIG"
  value         = var.semantic_config
  variable_type = "file"
}
