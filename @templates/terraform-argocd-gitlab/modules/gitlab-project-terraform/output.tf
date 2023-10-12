output "project_id" {
  value = gitlab_project.project.id
}

output "http_url_to_repo" {
  value = gitlab_project.project.http_url_to_repo
}
