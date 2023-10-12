resource "gitlab_project_hook" "atlantis-webhook" {
  count                   = var.webhook_atlantis_enabled ? 1 : 0
  project                 = gitlab_project.project.id
  url                     = format("https://%s/events", var.atlantis_host)
  push_events             = true
  note_events             = true
  merge_requests_events   = true
}
