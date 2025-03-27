data "terraform_remote_state" "aws" {
  backend = "s3"

  config = {
    bucket  = var.bucket
    region  = var.region   
    key     = var.key
  }
}
output "bucket_name" {
  value = aws_s3_bucket.bucket.id
}
