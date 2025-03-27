data "terraform_remote_state" "aws" {
  backend = "s3"

  config = {
    bucket  = "aws-s3-base-bucket-project-test"
    region  = var.region
    key     = var.key
  }
}
output "bucket_name" {
  value = data.aws_s3_bucket.existing_bucket.id
}
