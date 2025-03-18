#Resource allocation for AWS S3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket = "${var.project_name}-${var.region}-v1"
}

#Resource allocation for Step Function
resource "aws_sfn_state_machine" "data_injection_worflow" {
  name       = "data_injection_worflow"
  role_arn   = aws_iam_role.iam_sfn_role.arn
  definition = file("${path.module}/../aws/DataInjectionWorkflow.asl.json")

  type = "STANDARD"
}


#Resource allocation for AWS Lambda functions getDataFromApi and s3DataUpload
resource "aws_lambda_function" "lambda_getDataFromApi_resource" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${path.module}/../aws/getDataFromApi.zip"
  function_name = "getDataFromApi"
  role          = aws_iam_role.iam_lambda_role.arn
  handler       = "getDataFromApi.lambda_handler"


  source_code_hash = data.archive_file.lambda_getDataFromApi_data.output_base64sha256

  runtime = "python3.13"

}

resource "aws_lambda_function" "lambda_s3DataUpload_resource" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${path.module}/../aws/s3DataUpload.zip"
  function_name = "s3DataUpload"
  role          = aws_iam_role.iam_lambda_role.arn
  handler       = "s3DataUpload.lambda_handler"


  source_code_hash = data.archive_file.lambda_s3DataUpload_data.output_base64sha256

  runtime = "python3.13"
    environment {
    variables = {
      BUCKET_NAME = "${var.project_name}-${var.region}-v1"
    }
  }
}

#Resource importation for AWS Lambda s3DataUpload and getDataFromApi
data "archive_file" "lambda_getDataFromApi_data" {
  type        = "zip"
  source_file = "${path.module}/../aws/getDataFromApi.py" # Assurez-vous que le code source est dans ce dossier
  output_path = "${path.module}/../aws/getDataFromApi.zip"
}
data "archive_file" "lambda_s3DataUpload_data" {
  type        = "zip"
  source_file = "${path.module}/../aws/s3DataUpload.py" # Assurez-vous que le code source est dans ce dossier
  output_path = "${path.module}/../aws/s3DataUpload.zip"
}