run "function_creation" {
  assert {
    condition     = length(google_cloudfunctions2_function.function) == 2
    error_message = "Expected 2 functions to be created"
  }
}

run "function_service_account" {
  assert {
    condition     = google_service_account.function_bucket.account_id == "${var.waypoint_application}-fn-sa"
    error_message = "Service account ID does not match expected"
  }
}

run "function_bucket_access" {
  assert {
    condition     = google_storage_bucket_iam_member.function_bucket_access.role == "roles/storage.objectAdmin"
    error_message = "Bucket access role does not match expected"
  }
}

run "function_bucket_gha_access" {
  assert {
    condition     = google_storage_bucket_iam_member.function_bucket_gha_access.role == "roles/storage.objectAdmin"
    error_message = "Bucket access role for github actions does not match expected"
  }
}

run "public_access" {
  assert {
    condition     = google_cloud_run_v2_service_iam_member.public_access.role == "roles/run.invoker"
    error_message = "Public access role does not match expected"
  }
}