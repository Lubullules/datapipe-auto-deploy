resource "aws_sns_topic" "coinlore_snowpipe" {
  name = "${var.project_name}-coinlore-snowpipe-topic"
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
        "Resource" : "arn:aws:sns:${var.region}:${var.account_id}:${var.project_name}-coinlore-snowpipe-topic",
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
        "Resource" : "arn:aws:sns:${var.region}:${var.account_id}:${var.project_name}-coinlore-snowpipe-topic",
      }
    ]
  })
}

resource "aws_s3_bucket_notification" "coinlore_snowpipe_s3" {
  bucket = aws_s3_bucket.bucket.id

  topic {
    topic_arn     = aws_sns_topic.coinlore_snowpipe.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "coinlore/processed/"
  }
}

resource "aws_sns_topic" "reddit_snowpipe" {
  name = "${var.project_name}-reddit-snowpipe-topic"
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
        "Resource" : "arn:aws:sns:${var.region}:${var.account_id}:${var.project_name}-reddit-snowpipe-topic",
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
        "Resource" : "arn:aws:sns:${var.region}:${var.account_id}:${var.project_name}-reddit-snowpipe-topic",
      }
    ]
  })
}

resource "aws_s3_bucket_notification" "reddit_snowpipe_s3" {
  bucket = aws_s3_bucket.bucket.id

  topic {
    topic_arn     = aws_sns_topic.reddit_snowpipe.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "reddit/processed/"
  }
}