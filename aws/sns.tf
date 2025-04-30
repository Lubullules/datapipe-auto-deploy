resource "aws_sns_topic" "snowpipe_coinlore" {
  name_prefix = "${local.project_acronym_lower}-snowpipe-coinlore-topic"
}

resource "aws_sns_topic_policy" "snowpipe_coinlore" {
  arn = aws_sns_topic.snowpipe_coinlore.arn

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
        "Resource" : "${aws_sns_topic.snowpipe_coinlore.arn}",
        "Condition" : {
          "StringEquals" : {
            "aws:SourceAccount" : "${var.aws_account_id}"
          },
          "ArnLike" : {
            "aws:SourceArn" : "${aws_s3_bucket.data_bucket.arn}"
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
        "Resource" : "${aws_sns_topic.snowpipe_coinlore.arn}",
      }
    ]
  })
}

resource "aws_sns_topic" "snowpipe_reddit" {
  name_prefix = "${local.project_acronym_lower}-snowpipe-reddit-topic"
}

resource "aws_sns_topic_policy" "snowpipe_reddit" {
  arn = aws_sns_topic.snowpipe_reddit.arn

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
        "Resource" : "${aws_sns_topic.snowpipe_reddit.arn}",
        "Condition" : {
          "StringEquals" : {
            "aws:SourceAccount" : "${var.aws_account_id}"
          },
          "ArnLike" : {
            "aws:SourceArn" : "${aws_s3_bucket.data_bucket.arn}"
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
        "Resource" : "${aws_sns_topic.snowpipe_reddit.arn}",
      }
    ]
  })
}

resource "aws_s3_bucket_notification" "snowpipe_sns" {
  bucket = aws_s3_bucket.data_bucket.id

  topic {
    topic_arn     = aws_sns_topic.snowpipe_coinlore.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "coinlore/processed/"
  }

  topic {
    topic_arn     = aws_sns_topic.snowpipe_reddit.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "reddit/processed/"
  }
}
