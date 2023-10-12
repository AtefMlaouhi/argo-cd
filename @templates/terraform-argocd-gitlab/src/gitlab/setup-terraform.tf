module "terraform_project" {
  source = "git::ssh://git@git.harvest.fr:10022/O2S/o2s-modularisation/templates/terraform-argocd-gitlab.git//modules/gitlab-project-terraform?ref=main"

  project_name = var.project_terraform.name
  project_path = var.project_terraform.path

  atlantis_host = var.atlantis_host
}
