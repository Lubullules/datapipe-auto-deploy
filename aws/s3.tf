#Resource allocation for AWS S3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket        = "${var.project_name}-${var.env}-${var.region}"
  force_destroy = true

  logging {
    target_bucket = "aws-s3-base-bucket-project-test"
    target_prefix = "${var.project_name}-${var.env}-${var.region}-logs/"
  }
}