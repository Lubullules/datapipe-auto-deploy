#Resource allocation for AWS S3 bucket

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.project_name}-${var.region}-v1"
}

resource "aws_sfn_state_machine" "data_injection_worflow" {
  name     = "data_injection_worflow"
  role_arn = aws_iam_role.sfn_role.arn
  definition = file("${path.module}/../aws/DataInjectionWorkflow.asl.json")

  type = "STANDARD"
}

#Resource allocation for AWS IAM role for Lambda use

#Role for Lambda
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
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

#Policy for Lambda
resource "aws_iam_role_policy_attachment" "iam_for_lambda_policy" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

#Role for Step Function
resource "aws_iam_role" "sfn_role" {
  name = "sfn_role"
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

#Policy for Step Function
resource "aws_iam_role_policy_attachment" "sfn_role_policy" {
  role       = aws_iam_role.sfn_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSStepFunctionsFullAccess"
}

#Resource allocation for AWS Lambda getDataFromApi

data "archive_file" "lambda_getDataFromApi_data" {
  type        = "zip"
  source_file = "${path.module}/../aws/getDataFromApi.py" # Assurez-vous que le code source est dans ce dossier
  output_path = "${path.module}/../aws/getDataFromApi.zip"
}

resource "aws_lambda_function" "lambda_getDataFromApi_resource" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${path.module}/../aws/getDataFromApi.zip"
  function_name = "getDataFromApi"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"


  source_code_hash = data.archive_file.lambda_getDataFromApi_data.output_base64sha256

  runtime = "python3.13"

}

