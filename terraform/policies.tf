#Create policy for Step Function
resource "aws_iam_policy" "step_functions_policy" {
  name = "step_functions_policy"
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
resource "aws_iam_role_policy_attachment" "iam_sfn_policy" {
  role       = aws_iam_role.iam_sfn_role.name
  policy_arn = aws_iam_policy.step_functions_policy.arn
}

#Create policy for Lambda
resource "aws_iam_role_policy_attachment" "iam_lambda_policy" {
  role       = aws_iam_role.iam_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
