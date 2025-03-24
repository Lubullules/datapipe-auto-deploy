#Resource allocation for AWS S3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket_prefix = "${var.project_name}-${var.env}-${var.region}"
  force_destroy = true
}