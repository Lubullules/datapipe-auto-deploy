#Resource allocation for AWS S3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket        = "${var.project_name}-${var.region}-v1"
  force_destroy = true
}