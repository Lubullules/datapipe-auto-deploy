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
resource "aws_iam_role" "iam_cloudwatch_events_role" {
    name = "CloudwatchEventsRole"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
            Effect = "Allow",
            Principal = {
                Service = "events.amazonaws.com"
          
                },
            Action = "sts:AssumeRole"
            }
        ]
    })
}