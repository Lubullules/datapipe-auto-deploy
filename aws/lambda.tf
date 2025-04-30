#Resource allocation for AWS Lambda functions
resource "aws_lambda_function" "getDataFromCoinloreApi" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${path.module}/definitions/getDataFromCoinloreApi.zip"
  function_name = "${local.project_acronym_lower}-${var.env}-getDataFromCoinloreApi"
  role          = aws_iam_role.lambda.arn
  handler       = "getDataFromCoinloreApi.lambda_handler"
  timeout       = 60
  memory_size   = 512

  layers = ["arn:aws:lambda:eu-west-1:336392948345:layer:AWSSDKPandas-Python313:1"]

  source_code_hash = data.archive_file.getDataFromCoinloreApi_source.output_base64sha256

  runtime = "python3.13"

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.data_bucket.id
    }
  }
}

resource "aws_lambda_function" "processCoinloreData" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${path.module}/definitions/processCoinloreData.zip"
  function_name = "${local.project_acronym_lower}-${var.env}-processCoinloreData"
  role          = aws_iam_role.lambda.arn
  handler       = "processCoinloreData.lambda_handler"
  timeout       = 60
  memory_size   = 512

  layers = ["arn:aws:lambda:eu-west-1:336392948345:layer:AWSSDKPandas-Python313:1"]

  source_code_hash = data.archive_file.processCoinloreData_source.output_base64sha256

  runtime = "python3.13"

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.data_bucket.id
    }
  }
}

resource "aws_lambda_function" "getDataFromRedditApi" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${path.module}/definitions/getDataFromRedditApi.zip"
  function_name = "${local.project_acronym_lower}-${var.env}-getDataFromRedditApi"
  role          = aws_iam_role.lambda.arn
  handler       = "getDataFromRedditApi.lambda_handler"
  timeout       = 60
  memory_size   = 512

  layers = ["arn:aws:lambda:eu-west-1:336392948345:layer:AWSSDKPandas-Python313:1"]

  source_code_hash = data.archive_file.getDataFromRedditApi_source.output_base64sha256

  runtime = "python3.13"

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.data_bucket.id

      reddit_username      = var.reddit_username
      reddit_password      = var.reddit_password
      reddit_user_agent    = local.reddit_user_agent
      reddit_client_id     = var.reddit_client_id
      reddit_client_secret = var.reddit_client_secret
    }
  }
}

resource "aws_lambda_function" "processRedditData" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  image_uri     = "${aws_ecr_repository.lambda.repository_url}:latest"
  package_type  = "Image"
  function_name = "${local.project_acronym_lower}-${var.env}-processRedditData"
  role          = aws_iam_role.lambda.arn
  timeout       = 60
  memory_size   = 512

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.data_bucket.id
    }
  }

  depends_on = [null_resource.build_and_push_docker_image]
}