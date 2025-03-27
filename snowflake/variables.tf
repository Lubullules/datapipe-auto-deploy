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