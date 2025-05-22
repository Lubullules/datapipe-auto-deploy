data "terraform_remote_state" "aws" {
  backend = "s3"

  config = {
    bucket = var.base_bucket
    key    = var.aws_tf_state_key
    region = var.aws_region
  }
}