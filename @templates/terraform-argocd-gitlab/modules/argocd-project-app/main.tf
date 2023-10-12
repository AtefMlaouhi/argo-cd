resource "argocd_repository" "repository" {
  count = var.repository.create ? 1 : 0

  repo     = var.repository.url
  username = var.repository.username
  password = var.repository.password
  project  = var.repository.scoped ? var.project.name : ""

  provider = argocd.app
}

resource "argocd_project" "project" {
  count = var.project.create ? 1 : 0

  metadata {
    name = var.project.name
  }

  spec {
    description  = var.project.url
    source_repos = [var.repository.create ? argocd_repository.repository[0].repo : var.repository.url]

    namespace_resource_whitelist {
      group = "*"
      kind  = "*"
    }
    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }
    dynamic "cluster_resource_blacklist" {
      for_each = var.project.is_technical_project ? [] : ["ClusterRole", "ClusterRoleBinding"]
      content {
        group = "*"
        kind  = cluster_resource_blacklist.value
      }
    }

    # orphaned_resources {}

    dynamic "destination" {
      for_each = var.project.allowed_namespaces
      content {
        name      = "in-cluster"
        namespace = destination.value
        server    = "https://kubernetes.default.svc"
      }
    }
  }

  provider = argocd.project
}

locals {
  base_namespace = "%s-%s"
  envs           = var.env.envs
  NO_AUTO_SYNC = {
    prune       = false
    self_heal   = false
    allow_empty = false
  }
}

resource "argocd_application" "application" {
  for_each = { for env in local.envs : env.name => env }
  metadata {
    name      = var.env.use_env_naming ? format("%s-%s", var.app.name, each.value.name) : var.app.name
    namespace = "argocd"
    annotations = merge({
      "argocd.argoproj.io/manifest-generate-paths" = join(";", concat(["/${var.app.path}"], var.app.extra_paths))
    }, each.value.app_annotations)
  }

  spec {
    project                = var.project.create ? argocd_project.project[0].metadata.0.name : var.project.name
    revision_history_limit = 10

    source {
      repo_url        = var.repository.create ? argocd_repository.repository[0].repo : var.repository.url
      path            = var.app.path
      target_revision = each.value.target_revision != "" ? each.value.target_revision : var.app.target_revision

      helm {
        value_files = (length(each.value.values_files) > 0 ?
          each.value.values_files :
          concat(var.env.use_env_naming ?
            ["values.yaml", format("values-%s.yaml", each.value.name)] :
            ["values.yaml"],
            var.env.extra_values_files, each.value.extra_values_files
        ))

        dynamic "parameter" {
          for_each = each.value.parameters
          content {
            name  = parameter.value.name
            value = parameter.value.value
          }
        }
      }
    }

    dynamic "sync_policy" {
      for_each = (
        (each.value.name == "dev" && each.value.force_disable_autosync == false)
        || each.value.force_enable_autosync == true
        || (var.env.autosync_except_prod == true && (each.value.name != "prod") && each.value.force_disable_autosync == false)
      ? [each.value.name] : [])
      content {
        automated = {
          prune       = false
          self_heal   = true
          allow_empty = false
        }

        sync_options = ["ApplyOutOfSyncOnly=true"]

        retry {
          backoff = {
            duration     = ""
            max_duration = ""
          }
          limit = 0
        }
      }
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = var.env.use_env_naming ? format(local.base_namespace, var.namespace, each.value.name) : var.namespace
    }

    # https://argoproj.github.io/argo-rollouts/features/traffic-management/istio/#integrating-with-gitops
    # ignore_difference {
    #   group         = "networking.istio.io"
    #   kind          = "VirtualService"
    #   json_pointers = ["/spec/http/0"]
    # }
  }

  provider = argocd.app
}
