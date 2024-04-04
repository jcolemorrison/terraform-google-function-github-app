output "region_to_function_endpoints" {
  value       = zipmap(var.deployment_regions, [for func in google_cloudfunctions2_function.function : func.url])
  description = "Map of deployment regions to the public URI of the Cloud Function in that region"
}

output "github_repository_url" {
  value       = github_repository.application.html_url
  description = "The URL of the GitHub repository"
}