#Resource allocation for AWS S3 bucket

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.project_name}-${var.region}-v1"
}

#Resource allocation for AWS IAM role policy for Lambda use

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

#Resource allocation for AWS Lambda s3DataUpload

data "archive_file" "lambda_s3DataUpload_data" {
  type        = "zip"
  source_file = "${path.module}/../aws/s3DataUpload.py" # Assurez-vous que le code source est dans ce dossier
  output_path = "${path.module}/../aws/s3DataUpload.zip"
}

resource "aws_lambda_function" "lambda_s3DataUpload_resource" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${path.module}/../aws/s3DataUpload.zip"
  function_name = "s3DataUpload"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"


  source_code_hash = data.archive_file.lambda_s3DataUpload_data.output_base64sha256

  runtime = "python3.13"

}