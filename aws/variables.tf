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
  #Environment with the first letter capitalized
  env_capped = var.env == "dev" ? "Dev" : "Prod"
}

variable "project_name" {
  default     = "my-project"
  description = "The name of the project. Should be kebab-case."
  type        = string
}

locals {
  project_acronym_upper = upper(join("", [for part in split("-", var.project_name) : substr(part, 0, 1)]))

  project_acronym_lower = lower(local.project_acronym_upper)
}

# AWS specific variables
variable "aws_region" {
  default     = "eu-west-1"
  description = "The AWS region to deploy the resources in. Base bucket will be assumed to be in the same region."
  type        = string
}

variable "aws_account_id" {
  default     = "123456789012"
  description = "The AWS account ID where the resources will be deployed."
  type        = string
  sensitive   = true
}

variable "base_bucket" {
  default     = "my-s3-base-bucket"
  description = "The base S3 bucket to use for remote state and logs storage."
  type        = string
}

variable "snowflake_aws_user_arn" {
  default     = "arn:aws:iam::296062579650:user/abcd0000-s"
  description = "ARN of the AWS user dedicated by Snowflake"
  type        = string
  sensitive   = true
}

# Reddit specific variables
variable "reddit_username" {
  default     = "my-reddit-username"
  description = "Reddit username"
  type        = string
}

variable "reddit_password" {
  default     = "my-reddit-password"
  description = "Reddit password"
  type        = string
  sensitive   = true
}

variable "reddit_client_id" {
  default     = "my-reddit-client-id"
  description = "Client ID for Reddit"
  type        = string
  sensitive   = true
}

variable "reddit_client_secret" {
  default     = "my-reddit-client-secret"
  description = "Client secret for Reddit"
  type        = string
  sensitive   = true
}

locals {
  # The user agent string to use for the Reddit API requests
  reddit_user_agent = "${var.project_name}-${var.env} (by /u/${var.reddit_username})"
}