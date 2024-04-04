locals {
  run_env_vars = {
    for region in var.deployment_regions : region => merge(var.function_env_variables, {
        "REDIS_HOST" = "${var.redis_read_endpoints[region]}:6379"
    })
  }
}

# Get storage for base function code for first time deploy
data "google_storage_bucket" "base_template_bucket" {
  name = var.function_base_template_bucket_name
}

data "google_storage_bucket_object" "base_template_code" {
  name   = "base-fn-b0.1.3.zip"
  bucket = data.google_storage_bucket.base_template_bucket.name
}

# Create a storage bucket for the function source code
resource "google_storage_bucket" "function_bucket" {
  name                        = "${var.waypoint_application}-fn-source"
  location                    = "US"
  uniform_bucket_level_access = true
}

# Grab the function code from the main function bucket if version tag specified
data "google_storage_bucket_object" "function_code" {
  count  = var.function_version_tag != "" ? 1 : 0
  name   = "${var.waypoint_application}-${var.function_version_tag}.zip"
  bucket = google_storage_bucket.function_bucket.name
}

# Create a service account - for the function to manage bucket objects
resource "google_service_account" "function_bucket" {
  account_id   = "${var.waypoint_application}-fn-sa"
  display_name = "Function Base Template Service Account"
  project      = var.gcp_project_id
}

# Give the fn service account objectAdmin permissions to the bucket
resource "google_storage_bucket_iam_member" "function_bucket_access" {
  bucket = google_storage_bucket.function_bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.function_bucket.email}"
}

# Give the github actions service account objectAdmin permissions to the bucket
resource "google_storage_bucket_iam_member" "function_bucket_gha_access" {
  bucket = google_storage_bucket.function_bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.github_actions.email}"
}

# Create a Cloud Function for each region
resource "google_cloudfunctions2_function" "function" {
  count = length(var.deployment_regions)

  name     = format("${var.waypoint_application}-fn-%s", var.deployment_regions[count.index])
  location = var.deployment_regions[count.index]

  build_config {
    runtime = "nodejs20"
    environment_variables = local.run_env_vars[var.deployment_regions[count.index]]
    entry_point = "main"

    source {
      storage_source {
        bucket = var.function_version_tag != "" ? google_storage_bucket.function_bucket.name : data.google_storage_bucket.base_template_bucket.name
        object = var.function_version_tag != "" ? data.google_storage_bucket_object.function_code[0].name : data.google_storage_bucket_object.base_template_code.name
      }
    }
  }

  service_config {
    vpc_connector                 = var.regional_vpc_connector_ids[var.deployment_regions[count.index]]
    vpc_connector_egress_settings = "ALL_TRAFFIC"
    ingress_settings              = "ALLOW_ALL"
    service_account_email         = var.function_version_tag != "" ? google_service_account.function_bucket.email : var.function_service_account_email
    environment_variables = local.run_env_vars[var.deployment_regions[count.index]]
  }
}

# Create Default Cloud Run service
# resource "google_cloud_run_v2_service" "default" {
#   count    = length(var.deployment_regions)
#   name     = format("${var.waypoint_application}-fn-%s", var.deployment_regions[count.index])
#   location = var.deployment_regions[count.index]

#   template {
#     containers {
#       image = "${var.application_image_uri}:${var.application_image_tag}"

#       dynamic "env" {
#         for_each = local.run_env_vars[var.deployment_regions[count.index]]
#         content {
#           name  = env.value.name
#           value = env.value.value
#         }
#       }
#     }

#     vpc_access {
#       connector = var.regional_vpc_connector_ids[var.deployment_regions[count.index]]
#       egress    = "ALL_TRAFFIC"
#     }

#     service_account = var.app_service_account_email
#   }
# }

# Create a Network Endpoint Group for each Function
# resource "google_compute_region_network_endpoint_group" "function_endpoints" {
#   count  = length(var.deployment_regions)
#   name   = format("${var.waypoint_application}-%s", var.deployment_regions[count.index])
#   region = var.deployment_regions[count.index]

#   # May only work for v1 functions
#   # cloud_function {
#   #   function = google_cloudfunctions2_function.function[count.index].name
#   # }

#   # Since v2 functions are Cloud Run in the background
#   cloud_run {
#     service = google_cloudfunctions2_function.function[count.index].name
#   }
# }

# Create a backend service
# resource "google_compute_backend_service" "default_service" {
#   name                  = "${var.waypoint_application}-fn"
#   protocol              = "HTTPS"
#   enable_cdn            = false
#   load_balancing_scheme = "EXTERNAL_MANAGED"

#   dynamic "backend" {
#     for_each = google_compute_region_network_endpoint_group.default_serverless_endpoints
#     content {
#       group = backend.value.id
#     }
#   }
# }

# Grant public access to each Cloud Run service
resource "google_cloud_run_v2_service_iam_member" "public_access" {
  count    = length(var.deployment_regions)
  project  = var.gcp_project_id
  location = var.deployment_regions[count.index]
  name     = google_cloudfunctions2_function.function[count.index].name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
