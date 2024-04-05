
# WARNING: Generated module tests should be considered experimental and be reviewed by the module author.

run "region_to_function_endpoints" {
  assert {
    condition     = length(output.region_to_function_endpoints) == 2
    error_message = "Expected 2 function endpoints"
  }
}

run "github_repository_url" {
  assert {
    condition     = output.github_repository_url != ""
    error_message = "Expected non-empty repository URL"
  }
}