# This gitlab project contains the application itself AND the helm chart
module "gitlab-project-geocoding" {
  source = "git::ssh://git@git.harvest.fr:10022/O2S/o2s-modularisation/templates/terraform-argocd-gitlab.git//modules/gitlab-project-app?ref=main"

  project_name        = "fr.harvest.geocoding"
  project_path        = "O2S/o2s-modularisation/fr.harvest.geocoding"
  create_argocd_link  = true               # Create read token to the git repository for argocd (if the helm chart is in another repository, don't create the ArgoCD link here)
  argocd_hosts        = local.argocd_hosts # Urls to use for the argocd webhook (there are different urls if you want to use Flex cluster, cf https://git.harvest.fr/O2S/o2s-modularisation/templates/terraform-argocd-gitlab/-/blob/main/src/gitlab/main.tf#L41-58)
  write_token_enabled = true               # Example to create a write token on this repository
}

# Create the ArgoCD repository/applications
module "argocd-application-geocoding-api" {
  source = "../../modules/argocd-project-app"

  project = {
    name = "o2sm" # project name in ArgoCD
  }
  namespace = "geocoding" # Namespace in which applications will be deployed (suffixed by env.name, ex: geocoding-dev)
  app = {
    name = "geocoding-api"                   # Name of the applications that will be created in ArgoCD (suffixed by env.name)
    path = "deploy/fr.harvest.geocoding-api" # Path to the helm package within the repository
  }
  env = {
    # Each element of the envs array will make an ArgoCD application
    envs = [
      {
        name = "dev"
        parameters = [
          { name = "global.rancherCluster", value = var.rancher_clusterids.dev },
          { name = "global.rancherProject", value = var.rancher_projects.o2sm.dev }
        ]
      },
      {
        name = "rci"
        parameters = [
          { name = "global.rancherCluster", value = var.rancher_clusterids.dev },
          { name = "global.rancherProject", value = var.rancher_projects.o2sm.dev }
        ]
      }
    ]
  }
  repository = {
    create   = true # Create the ArgoCD repository containing the helm chart
    url      = "https://git.harvest.fr/O2S/o2s-modularisation/fr.harvest.geocoding.git"
    username = element(module.gitlab-project-geocoding.read_token.login, 0)
    password = element(module.gitlab-project-geocoding.read_token.value, 0) # Use the read token
  }

  providers = {                 # Terraform needs to know on which ArgoCD to create the resource (configured here https://git.harvest.fr/O2S/o2s-modularisation/templates/terraform-argocd-gitlab/-/blob/main/src/gitlab/main.tf#L6-39)
    argocd.project = argocd.dev # Just reference the `alias` of the ArgoCD
    argocd.app     = argocd.dev # Just reference the `alias` of the ArgoCD
  }
}
