resource "gitlab_branch_protection" "main" {
  project = gitlab_project.project.id
  branch  = var.default_branch

  push_access_level  = "maintainer"
  merge_access_level = "maintainer"

  allow_force_push = false
}
