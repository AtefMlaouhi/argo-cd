locals {
  project_path = split("/", var.project_path)
}

data "gitlab_group" "parent_group" {
  full_path = join("/", slice(local.project_path, 0, length(local.project_path) - 1))
}
