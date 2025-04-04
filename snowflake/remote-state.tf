data "terraform_remote_state" "aws" {
  backend = "s3"

  config = {
    bucket = var.bucket
    key    = var.aws_key
    region = var.region
  }
}

output "s3_bucket_name" {
  value = data.terraform_remote_state.aws.outputs.s3_bucket_name
}

output "snowpipe_role_arn" {
  value = data.terraform_remote_state.aws.outputs.snowpipe_role_arn
}