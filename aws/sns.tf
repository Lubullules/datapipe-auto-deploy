resource "aws_sns_topic" "snowpipe_topic" {
  name = "${var.project_name}-snowpipe-topic"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Id": "example-ID",
    "Statement": [
      {
        "Sid": "Example SNS topic policy",
        "Effect": "Allow",
        "Principal": {
          "Service": "s3.amazonaws.com"
        },
        "Action": "SNS:Publish",
        "Resource": "arn:aws:sns:${var.region}:${var.account_id}:${var.project_name}-snowpipe-topic",
        "Condition": {
          "StringEquals": {
            "aws:SourceAccount": "${var.account_id}"
          },
          "ArnLike": {
            "aws:SourceArn": "${aws_s3_bucket.bucket.arn}"
          }
        }
      },
      {
        "Sid": "1",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::296062579650:user/jqyv0000-s"
        },
        "Action": "sns:Subscribe",
        "Resource": "arn:aws:sns:${var.region}:${var.account_id}:${var.project_name}-snowpipe-topic",
      }
    ]
  })  
}

resource "aws_s3_bucket_notification" "snowpipe_s3_notification" {
  bucket = aws_s3_bucket.bucket.id

  topic {
    topic_arn = aws_sns_topic.snowpipe_sns_topic.arn
    events = ["s3:ObjectCreated:*"]
    filter_prefix = "processed/"
  }
}