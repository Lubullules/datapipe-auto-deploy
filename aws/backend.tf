# This file is used to configure the backend for Terraform state storage.
terraform {
  backend "s3" {
    region = ""
  }
}