#Role for Step Function
resource "aws_iam_role" "step_function" {
  name = "${local.project_acronym_upper}${local.env_capped}StepFunctionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "states.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

#Role for Lambda
resource "aws_iam_role" "lambda" {
  name = "${local.project_acronym_upper}${local.env_capped}LambdaRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

#Role for CloudWatch Events
resource "aws_iam_role" "scheduler" {
  name = "${local.project_acronym_upper}${local.env_capped}SchedulerRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "scheduler.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

#Create policy for Step Function
resource "aws_iam_policy" "step_function" {
  name = "${local.project_acronym_upper}${local.env_capped}StepFunctionInvokeLambdaPolicy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "lambda:InvokeFunction"
        ],
        "Resource" : [
          "${aws_lambda_function.getDataFromCoinloreApi.arn}",
          "${aws_lambda_function.processCoinloreData.arn}",
          "${aws_lambda_function.getDataFromRedditApi.arn}",
          "${aws_lambda_function.processRedditData.arn}"
        ]
      }
    ]
  })
}

#Attach policy for Step Function
resource "aws_iam_role_policy_attachment" "step_function" {
  role       = aws_iam_role.step_function.name
  policy_arn = aws_iam_policy.step_function.arn
}

#Create policy for Lambda
resource "aws_iam_policy" "lambda_s3" {
  name = "${local.project_acronym_upper}${local.env_capped}LambdaReadWriteS3BucketPolicy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:GetObjectAcl",
          "s3:PutObject",
          "s3:PutObjectAcl"
        ],
        "Resource" : [
          "${aws_s3_bucket.data_bucket.arn}",
          "${aws_s3_bucket.data_bucket.arn}/*"
        ]
      }
    ]
  })
}

#Attach policies for Lambda
resource "aws_iam_role_policy_attachment" "lambda_log" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_s3" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda_s3.arn
}

#Create policy for Scheduler
resource "aws_iam_policy" "scheduler_sfn" {
  name = "${local.project_acronym_upper}${local.env_capped}SchedulerStartStepFunctionExecutionPolicy"
  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Effect" = "Allow",
        "Action" = [
          "states:StartExecution"
        ],
        "Resource" = "${aws_sfn_state_machine.data_injection_workflow.arn}"
      }
    ]
  })
}

#Attach policy for Scheduler
resource "aws_iam_role_policy_attachment" "schedule" {
  role       = aws_iam_role.scheduler.name
  policy_arn = aws_iam_policy.scheduler_sfn.arn
}

#Create a random external ID for the Snowpipe role
resource "random_string" "snowpipe_external_id" {
  length  = 16
  special = false
}

#Create role for Snowpipe
resource "aws_iam_role" "snowpipe" {
  name = "${local.project_acronym_upper}${local.env_capped}SnowpipeRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "${var.snowflake_aws_user_arn}"
        },
        Action = "sts:AssumeRole",
        Condition = {
          StringEquals = {
            "sts:ExternalId" = "${random_string.snowpipe_external_id.result}"
          }
        }
      }
    ]
  })
}

#Create policy for Snowpipe
resource "aws_iam_policy" "snowpipe_s3" {
  name = "${local.project_acronym_upper}${local.env_capped}SnowpipeS3Policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:GetObjectVersion",
        ],
        "Resource" : [
          "${aws_s3_bucket.data_bucket.arn}/coinlore/processed/*",
          "${aws_s3_bucket.data_bucket.arn}/reddit/processed/*",
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:GetBucketLocation",
        ],
        "Resource" : [
          "${aws_s3_bucket.data_bucket.arn}",
        ],
        "Condition" : {
          "StringLike" : {
            "s3:prefix" : [
              "coinlore/processed/*",
              "reddit/processed/*"
            ]
          }
        }
      }
    ]
  })
}

#Attach policy for Snowpipe
resource "aws_iam_role_policy_attachment" "snowpipe" {
  role       = aws_iam_role.snowpipe.name
  policy_arn = aws_iam_policy.snowpipe_s3.arn
}
