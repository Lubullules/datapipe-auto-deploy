#Role for Step Function
resource "aws_iam_role" "iam_sfn_role" {
  name = "StepFunctionsRole"
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
  name = "LambdaRole"
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
  name = "SchedulerRole"
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
  name = "StepFunctionsInvokeLambdaPolicy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "lambda:InvokeFunction"
        ],
        "Resource" : [
          "${aws_lambda_function.lambda_getDataFromApi_resource.arn}:*",
          "${aws_lambda_function.lambda_s3DataUpload_resource.arn}:*",
          "${aws_lambda_function.lambda_cleanTransformData_resource.arn}:*"
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
  name = "LambdaPutInS3BucketPolicy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:PutObjectAcl"
        ],
        "Resource" : [
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
  name = "SchedulerStartStepFunctionExecutionPolicy"
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
