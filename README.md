# Scaling Infrastructure as Code on Google Cloud Platform

The Google Cloud Platform facing cloud infrastructure demo code for the Google Next '24 talk "Scaling Infrastructure as Code: Proven Strategies and Productive Workflows".  

This is the repo used to create an application deployment pipeline for developers via HCP Waypoint.

## Usage

```
module "function-github-app" {
  source  = "app.terraform.io/hashicorp-team-demo/function-github-app/google"
  version = "0.1.6"
  # insert required variables here
}
```