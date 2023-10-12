resource "gitlab_branch_protection" "main" {
  project                = gitlab_project.project.id
  branch                 = var.default_branch

  push_access_level      = "maintainer"
  merge_access_level     = "developer"

  allow_force_push       = false
}

resource "gitlab_tag_protection" "harvest" {
  project             = gitlab_project.project.id
  tag                 = "harvest-*"
  create_access_level = "maintainer"
}
