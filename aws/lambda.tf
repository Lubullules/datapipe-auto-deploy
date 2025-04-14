#Resource allocation for AWS Lambda functions
resource "aws_lambda_function" "lambda_getDataFromApi_resource" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${path.module}/definitions/getDataFromApi.zip"
  function_name = "${var.project_name}-${var.env}-getDataFromApi"
  role          = aws_iam_role.iam_lambda_role.arn
  handler       = "getDataFromApi.lambda_handler"
  timeout       = 60
  memory_size   = 512

  layers = ["arn:aws:lambda:eu-west-1:336392948345:layer:AWSSDKPandas-Python313:1"]

  source_code_hash = data.archive_file.lambda_getDataFromApi_data.output_base64sha256

  runtime = "python3.13"

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.bucket.bucket
    }
  }
}

resource "aws_lambda_function" "lambda_processData_resource" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${path.module}/definitions/processData.zip"
  function_name = "${var.project_name}-${var.env}-processData"
  role          = aws_iam_role.iam_lambda_role.arn
  handler       = "processData.lambda_handler"
  timeout       = 60
  memory_size   = 512

  layers = ["arn:aws:lambda:eu-west-1:336392948345:layer:AWSSDKPandas-Python313:1"]

  source_code_hash = data.archive_file.lambda_processData_data.output_base64sha256

  runtime = "python3.13"

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.bucket.bucket
    }
  }
}

resource "aws_lambda_function" "lambda_processRedditData_resource" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  image_uri = "${aws_ecr_repository.reddit_data_repo.repository_url}:latest"
  package_type = "Image"
  function_name = "${var.project_name}-${var.env}-processRedditData"
  role          = aws_iam_role.iam_lambda_role.arn
  handler       = "processRedditData.lambda_handler"
  timeout       = 60
  memory_size   = 512

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.bucket.bucket
    }
  }
}