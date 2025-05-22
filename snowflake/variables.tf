# Project specific variables
variable "env" {
  default     = "dev"
  description = "The environment to deploy the resources in. Must be either 'dev' or 'prod'."
  type        = string
  validation {
    condition     = contains(["dev", "prod"], var.env)
    error_message = "The environment must be either 'dev' or 'prod'."
  }
}

locals {
  #Capitalize the environment
  env_capped = upper(var.env)
}

variable "project_name" {
  default     = "my-project"
  description = "The name of the project. Should be kebab-case."
  type        = string
}

locals {
  project_acronym_upper = upper(join("", [for part in split("-", var.project_name) : substr(part, 0, 1)]))
}

variable "aws_region" {
  default     = "eu-west-1"
  description = "The AWS region to deploy the resources in. Base bucket will be assumed to be in the same region."
  type        = string
}

variable "base_bucket" {
  default     = "my-s3-base-bucket"
  description = "The base S3 bucket to use for remote state and logs storage."
  type        = string
}

variable "aws_tf_state_key" {
  default     = "aws_dev/terraform.tfstate"
  description = "The S3 key for the AWS Terraform state file."
  type        = string
}

variable "snowflake_private_key" {
  description = "The private key used for authentication with Snowflake."
  type        = string
  sensitive   = true
}

variable "snowflake_org_name" {
  default     = "my-org"
  description = "The name of the Snowflake organization."
  type        = string
}

variable "snowflake_account_name" {
  default     = "my-account"
  description = "The name of the Snowflake account."
  type        = string
}

variable "snowflake_user" {
  default     = "TF-SNOW-USER"
  description = "The Snowflake user used by Terraform to manage resources."
  type        = string
}

variable "snowflake_role" {
  default     = "TF-SNOW-ROLE"
  description = "The Snowflake role used by Terraform to manage resources."
  type        = string
}