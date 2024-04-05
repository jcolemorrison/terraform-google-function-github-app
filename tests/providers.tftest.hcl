
# WARNING: Generated module tests should be considered experimental and be reviewed by the module author.

run "google_provider" {
  assert {
    condition     = google.project == var.gcp_project_id
    error_message = "Google provider project ID does not match expected"
  }
}

run "github_provider" {
  assert {
    condition     = github.token != ""
    error_message = "Expected non-empty Github token"
  }
}