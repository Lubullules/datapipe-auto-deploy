data "terraform_remote_state" "aws" {
  backend = "s3"

  config = {
    region = var.region
    bucket = var.bucket
    key    = var.aws_key
  }
}