# Checks for Function status in initial deployment regions

check "check_cf_state_west" {
  data "google_cloudfunctions2_function" "live_function_west" {
    name = format("${var.waypoint_application}-fn-%s", var.deployment_regions[0])
    location = var.deployment_regions[0]
  }
  assert {
    condition = data.google_cloudfunctions2_function.live_function_west.state == "ACTIVE"
    error_message = format("Provisioned Cloud Functions should be in an ACTIVE state, instead the function `%s` has state: %s",
      data.google_cloudfunctions2_function.live_function_west.name,
      data.google_cloudfunctions2_function.live_function_west.state
    )
  }
}

check "check_cf_state_east" {
  data "google_cloudfunctions2_function" "live_function_east" {
    name = format("${var.waypoint_application}-fn-%s", var.deployment_regions[1])
    location = var.deployment_regions[1]
  }
  assert {
    condition = data.google_cloudfunctions2_function.live_function_east.state == "ACTIVE"
    error_message = format("Provisioned Cloud Functions should be in an ACTIVE state, instead the function `%s` has state: %s",
      data.google_cloudfunctions2_function.live_function_east.name,
      data.google_cloudfunctions2_function.live_function_east.state
    )
  }
}