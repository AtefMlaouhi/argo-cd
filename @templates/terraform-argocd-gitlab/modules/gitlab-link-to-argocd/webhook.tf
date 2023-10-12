resource "gitlab_project_hook" "argocd-webhook" {
  for_each    = toset(var.argocd_hosts)
  project     = var.project_id
  url         = format("https://%s/api/webhook", each.value)
  push_events = true
}
