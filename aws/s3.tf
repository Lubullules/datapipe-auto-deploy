#TODO: Add a description of the purpose of this file and the resources

#Resource allocation for AWS S3 bucket
resource "aws_s3_bucket" "data_bucket" {
  bucket_prefix = "${var.project_name}-${var.env}-${var.aws_region}-"
  force_destroy = true
}

resource "aws_s3_bucket_logging" "data_bucket" {
  bucket = aws_s3_bucket.data_bucket.id

  target_bucket = var.base_bucket
  target_prefix = "${aws_s3_bucket.data_bucket.id}_logs/"
}