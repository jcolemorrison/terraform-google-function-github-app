run "tfc_organization" {
  assert {
    condition     = var.tfc_organization != ""
    error_message = "Expected non-empty tfc_organization"
  }
}

run "gcp_project_id" {
  assert {
    condition     = var.gcp_project_id != ""
    error_message = "Expected non-empty gcp_project_id"
  }
}

run "default_region" {
  assert {
    condition     = var.default_region == "us-west1"
    error_message = "Default region does not match expected"
  }
}

run "deployment_regions" {
  assert {
    condition     = length(var.deployment_regions) == 2
    error_message = "Expected 2 deployment regions"
  }
}

run "github_token" {
  assert {
    condition     = var.github_token != ""
    error_message = "Expected non-empty github_token"
  }
}

run "github_template_owner" {
  assert {
    condition     = var.github_template_owner != ""
    error_message = "Expected non-empty github_template_owner"
  }
}

run "github_template_repo" {
  assert {
    condition     = var.github_template_repo != ""
    error_message = "Expected non-empty github_template_repo"
  }
}

run "redis_read_endpoints" {
  assert {
    condition     = length(var.redis_read_endpoints) == 2
    error_message = "Expected no redis_read_endpoints"
  }
}

run "waypoint_application" {
  assert {
    condition     = var.waypoint_application != ""
    error_message = "Expected non-empty waypoint_application"
  }
}

run "function_service_account_email" {
  assert {
    condition     = var.function_service_account_email != ""
    error_message = "Expected non-empty function_service_account_email"
  }
}

run "function_env_variables" {
  assert {
    condition     = length(var.function_env_variables) == 0
    error_message = "Expected no function_env_variables"
  }
}

run "function_base_template_bucket_name" {
  assert {
    condition     = var.function_base_template_bucket_name != ""
    error_message = "Expected non-empty function_base_template_bucket_name"
  }
}

run "function_version_tag" {
  assert {
    condition     = var.function_version_tag == ""
    error_message = "Expected empty function_version_tag"
  }
}

run "base_function_version_tag" {
  assert {
    condition     = var.base_function_version_tag == "b0.1.4"
    error_message = "Base function version tag does not match expected"
  }
}

run "regional_vpc_connector_ids" {
  assert {
    condition     = length(var.regional_vpc_connector_ids) == 2
    error_message = "Expected no regional_vpc_connector_ids"
  }
}