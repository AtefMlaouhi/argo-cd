resource "gitlab_project" "project" {
  name         = var.project_name
  namespace_id = data.gitlab_group.parent_group.group_id

  initialize_with_readme                           = false
  issues_enabled                                   = false
  merge_method                                     = "ff"
  only_allow_merge_if_all_discussions_are_resolved = true
  only_allow_merge_if_pipeline_succeeds            = var.only_allow_merge_if_pipeline_succeeds
  remove_source_branch_after_merge                 = true
  squash_option                                    = "default_on"
  visibility_level                                 = "internal"
  ci_default_git_depth                             = var.ci_fetch_default_git_depth
  pipelines_enabled                                = var.pipelines_enabled
  wiki_enabled                                     = false
  default_branch                                   = "main"
  mr_default_target_self                           = true # if fork, make MR to same project and not upstream
  squash_commit_template                           = <<-EOF
    %%{title}

    %%{all_commits}
EOF

  lifecycle {
    prevent_destroy = true
  }
}

# resource "gitlab_project_membership" "gitlab-cd-push-membership" {
#   project_id   = data.gitlab_project.project-app.id
#   user_id      = gitlab_project_access_token.geocoding-gitlab-cd-push.user_id
#   access_level = "maintainer"
# }
