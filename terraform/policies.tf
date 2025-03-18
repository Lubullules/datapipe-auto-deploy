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
          "arn:aws:lambda:${var.region}:${var.account_id}:function:s3DataUpload:*",
          "arn:aws:lambda:${var.region}:${var.account_id}:function:getDataFromApi:*"
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
resource "aws_iam_policy" "lambda_policy" {
  name = "LambdaPutInS3BucketPolicy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3.PutObject"
        ],
        "Resource" : [
          "${aws_s3_bucket.bucket.arn}"
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
  policy_arn = aws_iam_policy.lambda_policy.arn
}

