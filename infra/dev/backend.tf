terraform {
  backend "gcs" {
    bucket = "capstone-terraform-state-buckets"
    prefix = "terraform/state/dev"
  }
}