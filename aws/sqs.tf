resource "aws_sqs_queue" "snowpipe_queue" {
  name                      = "snowpipe-queue"
  visibility_timeout_seconds = 300
}

resource "aws_s3_bucket_notification" "snowpipe_s3_notification" {
  bucket = aws_s3_bucket.snowpipe_bucket.id

  queue {
    queue_arn     = aws_sqs_queue.snowpipe_queue.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "processed/"
  }
}