variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "bucket" {
  type    = string
  default = "aws-s3-base-bucket-project-test"
}

variable "key" {
  type    = string
  default = "test-remote-config-lock-bug/terraform.tfstate"
}

variable "snowflake_org_name" {
  type    = string
  default = "JLWJSHF"
}

variable "snowflake_account_name" {
  type    = string
  default = "BJ18758"
}

variable "snowflake_user" {
  type    = string
  default = "TF-SNOW-USER"
}

variable "snowflake_private_key" {
  type      = string
  sensitive = true
}

variable "snowflake_role" {
  type    = string
  default = "TF-SNOW-ROLE"
}