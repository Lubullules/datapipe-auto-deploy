#Resource allocation for AWS Lambda functions getDataFromApi, cleanTransformData and s3DataUpload
resource "aws_lambda_function" "lambda_getDataFromApi_resource" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${path.module}/../aws/getDataFromApi.zip"
  function_name = "${var.project_name}-${var.env}-getDataFromApi"
  role          = aws_iam_role.iam_lambda_role.arn
  handler       = "getDataFromApi.lambda_handler"

  source_code_hash = data.archive_file.lambda_getDataFromApi_data.output_base64sha256

  runtime = "python3.13"

}

resource "aws_lambda_function" "lambda_cleanTransformData_resource" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${path.module}/../aws/cleanTransformData.zip"
  function_name = "${var.project_name}-${var.env}-cleanTransformData"
  role          = aws_iam_role.iam_lambda_role.arn
  handler       = "cleanTransformData.lambda_handler"

  source_code_hash = data.archive_file.lambda_cleanTransformData_data.output_base64sha256

  runtime = "python3.13"
}

resource "aws_lambda_function" "lambda_s3DataUpload_resource" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${path.module}/../aws/s3DataUpload.zip"
  function_name = "${var.project_name}-${var.env}-s3DataUpload"
  role          = aws_iam_role.iam_lambda_role.arn
  handler       = "s3DataUpload.lambda_handler"
  timeout       = 60

  layers = ["arn:aws:lambda:eu-west-1:336392948345:layer:AWSSDKPandas-Python313:1"]

  source_code_hash = data.archive_file.lambda_s3DataUpload_data.output_base64sha256

  runtime = "python3.13"

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.bucket.bucket
    }
  }
}