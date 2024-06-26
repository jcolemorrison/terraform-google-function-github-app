variable "tfc_organization" {
  description = "Terraform Cloud Organization name"
  type        = string
  default     = ""
}

variable "tfc_api_token" {
  description = "Terraform Cloud API token for github actions"
  type        = string
  sensitive   = true
  default     = ""
}

variable "gcp_project_id" {
  description = "The ID of the GCP project"
  type        = string
  default     = ""
}

variable "default_region" {
  description = "default region for the project deployment"
  type        = string
  default     = "us-west1"
}

variable "deployment_regions" {
  description = "regions to deploy"
  type        = list(string)
  default     = ["us-west1", "us-east1"]
}

variable "github_token" {
  description = "Valid access token for Github with public_repo and delete_repo permissions"
  type        = string
  sensitive   = true
  default     = ""
}

variable "github_template_owner" {
  description = "The name of the owner ororganization in Github that will contain the template repo."
  type        = string
  default     = ""
}

variable "github_template_repo" {
  description = "The name of the repository in Github that contains the template repo."
  type        = string
  default     = ""
}

variable "redis_read_endpoints" {
  description = "The list of Redis read endpoints."
  type        = map(string)
  default     = {}
}

variable "waypoint_application" {
  type        = string
  description = "Name of the Waypoint application or no-code module workspace."

  validation {
    condition     = !contains(["-", "_"], var.waypoint_application)
    error_message = "waypoint_application must not contain dashes or underscores."
  }
}


variable "function_service_account_email" {
  description = "Email of the GCP service account with permissions from the services and core projects."
  type        = string
  default     = ""
}

variable "function_env_variables" {
  description = "The environment variables to set in the function."
  type        = map(string)
  default     = {}
}

variable "function_base_template_bucket_name" {
  description = "The name of the bucket containing the base function template."
  type        = string
  default     = ""
}

variable "function_version_tag" {
  description = "The version tag for the function."
  type        = string
  default     = ""
}

variable "base_function_version_tag" {
  description = "The version tag for the base function used on first deploy."
  type        = string
  default     = "b0.1.4"
}

variable "regional_vpc_connector_ids" {
  description = "A map of regional VPC connector IDs."
  type        = map(string)
  default     = {}
}