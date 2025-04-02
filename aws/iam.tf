#Role for Step Function
resource "aws_iam_role" "iam_sfn_role" {
  name = "${var.project_name}-${var.env}-StepFunctionsRole"
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
resource "aws_iam_role" "iam_lambda_role" {
  name = "${var.project_name}-${var.env}-LambdaRole"
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
resource "aws_iam_role" "iam_scheduler_role" {
  name = "${var.project_name}-${var.env}-SchedulerRole"
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
resource "aws_iam_policy" "step_functions_policy" {
  name = "${var.project_name}-${var.env}-StepFunctionsInvokeLambdaPolicy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "lambda:InvokeFunction"
        ],
        "Resource" : [
          "${aws_lambda_function.lambda_getDataFromApi_resource.arn}",
          "${aws_lambda_function.lambda_processData_resource.arn}",
        ]
      }
    ]
  })
}

#Attach policy for Step Function
resource "aws_iam_role_policy_attachment" "sfn_policy_attachment" {
  role       = aws_iam_role.iam_sfn_role.name
  policy_arn = aws_iam_policy.step_functions_policy.arn
}

#Create policy for Lambda
resource "aws_iam_policy" "lambda_s3_policy" {
  name = "${var.project_name}-${var.env}-LambdaReadWriteS3BucketPolicy"
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
          "${aws_s3_bucket.bucket.arn}",
          "${aws_s3_bucket.bucket.arn}/*"
        ]
      }
    ]
  })
}

#Attach policies for Lambda
resource "aws_iam_role_policy_attachment" "lambda_log_policy_attachment" {
  role       = aws_iam_role.iam_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_s3_policy_attachment" {
  role       = aws_iam_role.iam_lambda_role.name
  policy_arn = aws_iam_policy.lambda_s3_policy.arn
}

#Create policy for Scheduler
resource "aws_iam_policy" "scheduler_sfn_policy" {
  name = "${var.project_name}-${var.env}-SchedulerStartStepFunctionExecutionPolicy"
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
resource "aws_iam_role_policy_attachment" "scheduler_policy_attachment" {
  role       = aws_iam_role.iam_scheduler_role.name
  policy_arn = aws_iam_policy.scheduler_sfn_policy.arn
}

#Create role for Snowflake Snowpipe
resource "aws_iam_role" "iam_snowpipe_role" {
  name = "${var.project_name}-${var.env}-SnowpipeRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::296062579650:user/jqyv0000-s"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

#Create policy for Snowpipe
resource "aws_iam_policy" "snowpipe_s3_policy" {
  name = "${var.project_name}-${var.env}-SnowpipeS3Policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        "Resource" : [
          "${aws_s3_bucket.bucket.arn}",
          "${aws_s3_bucket.bucket.arn}/*"
        ]
      }
    ]
  })
}

#Attach policy for Snowpipe
resource "aws_iam_role_policy_attachment" "snowpipe_policy_attachment" {
  role       = aws_iam_role.iam_snowpipe_role.name
  policy_arn = aws_iam_policy.snowpipe_s3_policy.arn
}