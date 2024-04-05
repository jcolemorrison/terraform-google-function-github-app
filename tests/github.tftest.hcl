run "github_repository" {
  assert {
    condition     = github_repository.application.visibility == "public"
    error_message = "Repository visibility does not match expected"
  }
}

run "github_repository_file" {
  assert {
    condition     = github_repository_file.readme.file == "README.md"
    error_message = "Repository file does not match expected"
  }
}

run "github_actions_secret" {
  assert {
    condition     = github_actions_secret.gcp_credentials.secret_name == "GCP_SA_KEY"
    error_message = "Secret name does not match expected"
  }
}