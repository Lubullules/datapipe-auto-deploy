#Policy for Step Function
resource "aws_iam_role_policy_attachment" "sfn_role_policy" {
  role       = aws_iam_role.sfn_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSStepFunctionsFullAccess"
}
#Policy for Lambda
resource "aws_iam_role_policy_attachment" "iam_for_lambda_policy" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
