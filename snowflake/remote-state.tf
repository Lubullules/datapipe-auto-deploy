data "terraform_remote_state" "aws" {
  backend = "s3"

  config = {
    region = var.region
    bucket = var.bucket
    key    = var.aws_key
  }

  outputs = {
    s3_bucket_name    = aws_s3_bucket.bucket.id
    snowpipe_role_arn = aws_iam_role.iam_snowpipe_role.arn
  }
}