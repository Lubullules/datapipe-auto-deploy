#TODO: Add a description of the purpose of this file and the resources

#Resource allocation for AWS S3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket        = "${var.project_name}-${var.env}-${var.region}"
  force_destroy = true
}

resource "aws_s3_bucket_logging" "data_bucket" {
  bucket = aws_s3_bucket.bucket.id

  #TODO: var the base bucket name
  target_bucket = "aws-s3-base-bucket-project-test"
  target_prefix = "data_logs/"
}