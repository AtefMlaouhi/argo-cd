argocd_hosts = {
  dev       = "argocd-k8s.dev.harvest.fr"
  dev_flex  = "argocd.flex-dev.harvest.fr"
  preprod   = "argocd-k8s.preprod.harvest.fr"
  prod      = "argocd.harvest.fr"
  prod_flex = "argocd-flex.harvest.fr"
}

rancher_clusterids = {
  dev       = "c-btmpm"
  preprod   = "c-mtw66"
  prod      = "c-4cv2w"
  dev_flex  = "c-m-qbctwmg7"
  prod_flex = "c-m-h2rkm56h"
}

rancher_projects = {
  o2sm = {
    dev     = "p-82dsv"
    preprod = "p-5qtm6"
    prod    = "p-57lwd"
  }
}

atlantis_host = "atlantis-k8s.dev.harvest.fr"

# project_terraform = {
#   name = "" # ex: "terraform-argocd-gitlab"
#   path = "" # ex: "O2S/o2s-modularisation/poc/terraform-argocd-gitlab"
# }
