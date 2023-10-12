variable "repository" {
  type = object({
    create   = optional(bool, false)
    url      = string
    username = optional(string, "")
    password = optional(string, "")
    scoped   = optional(bool, false)
  })
}

variable "project" {
  type = object({
    create               = optional(bool, false)
    name                 = string
    url                  = optional(string, "")
    allowed_namespaces   = optional(list(string), [])
    is_technical_project = optional(bool, false)
  })
  description = <<EOF
  - is_technical_project controls cluster_resource_blacklist on the project (eg: ClusterRole are allowed for tech env but not for regular ones)
EOF
}

variable "app" {
  type = object({
    name            = string
    path            = string
    target_revision = optional(string, "HEAD")
    extra_paths     = optional(list(string), [])
  })
  description = "Path to the application from git root folder."
}

variable "env" {
  type = object({
    envs = optional(list(object({
      name                   = string
      app_annotations        = optional(map(string), {})
      values_files           = optional(list(string), [])
      extra_values_files     = optional(list(string), [])
      force_disable_autosync = optional(bool, false)
      force_enable_autosync  = optional(bool, false)
      parameters = optional(list(object({
        name  = string
        value = string
      })), [])
      target_revision = optional(string, "")
    })))
    extra_values_files   = optional(list(string), [])
    use_env_naming       = optional(bool, true)
    autosync_except_prod = optional(bool, false)
  })
  description = <<EOF
  - use_env_naming suffixes namespaces & release name by the environment name, it also includes values-{env}.yaml files to the helm release
  - extra_values_files adds values.yaml to all environments, if you want different files per env => use env.envs.extra_values_files
EOF
}

variable "namespace" {
  type = string
}
