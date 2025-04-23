resource "aws_sns_topic" "snowpipe-coinlore" {
  name_prefix = "${var.project_name}-snowpipe-coinlore-topic-test-"
}

resource "aws_sns_topic_policy" "coinlore" {
  arn = aws_sns_topic.snowpipe-coinlore.arn

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "example-ID",
    "Statement" : [
      {
        "Sid" : "Example SNS topic policy",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "s3.amazonaws.com"
        },
        "Action" : "SNS:Publish",
        "Resource" : "${aws_sns_topic.snowpipe-coinlore.arn}",
        "Condition" : {
          "StringEquals" : {
            "aws:SourceAccount" : "${var.account_id}"
          },
          "ArnLike" : {
            "aws:SourceArn" : "${aws_s3_bucket.bucket.arn}"
          }
        }
      },
      {
        "Sid" : "1",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "${var.snowflake_aws_user_arn}"
        },
        "Action" : "sns:Subscribe",
        "Resource" : "${aws_sns_topic.snowpipe-coinlore.arn}",
      }
    ]
  })
}

resource "aws_sns_topic" "snowpipe-reddit" {
  name_prefix = "${var.project_name}-snowpipe-reddit-topic-test-"
}

resource "aws_sns_topic_policy" "reddit" {
  arn = aws_sns_topic.snowpipe-reddit.arn

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "example-ID",
    "Statement" : [
      {
        "Sid" : "Example SNS topic policy",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "s3.amazonaws.com"
        },
        "Action" : "SNS:Publish",
        "Resource" : "${aws_sns_topic.snowpipe-reddit.arn}",
        "Condition" : {
          "StringEquals" : {
            "aws:SourceAccount" : "${var.account_id}"
          },
          "ArnLike" : {
            "aws:SourceArn" : "${aws_s3_bucket.bucket.arn}"
          }
        }
      },
      {
        "Sid" : "1",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "${var.snowflake_aws_user_arn}"
        },
        "Action" : "sns:Subscribe",
        "Resource" : "${aws_sns_topic.snowpipe-reddit.arn}",
      }
    ]
  })
}

resource "aws_s3_bucket_notification" "snowpipe_s3" {
  bucket = aws_s3_bucket.bucket.id

  topic {
    topic_arn     = aws_sns_topic.snowpipe-coinlore.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "coinlore/processed/"
  }

  topic {
    topic_arn     = aws_sns_topic.snowpipe-reddit.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "reddit/processed/"
  }
}
