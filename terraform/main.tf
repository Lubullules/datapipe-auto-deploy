#Resource allocation for AWS S3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket        = "${var.project_name}-${var.region}-v1"
  force_destroy = true
}


#Resource allocation for Step Function
resource "aws_sfn_state_machine" "data_injection_workflow" {
  name       = "DataInjectionWorkflow"
  role_arn   = aws_iam_role.iam_sfn_role.arn
  definition = file("${path.module}/../aws/DataInjectionWorkflow.asl.json")

  type = "STANDARD"
}


#Resource allocation for AWS Lambda functions getDataFromApi, cleanTransformData and s3DataUpload
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

resource "aws_lambda_function" "lambda_cleanTransformData_resource" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${path.module}/../aws/cleanTransformData.zip"
  function_name = "cleanTransformData"
  role          = aws_iam_role.iam_lambda_role.arn
  handler       = "cleanTransformData.lambda_handler"

  source_code_hash = data.archive_file.lambda_cleanTransformData_data.output_base64sha256

  runtime = "python3.13"
}

resource "aws_lambda_function" "lambda_s3DataUpload_resource" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${path.module}/../aws/s3DataUpload.zip"
  function_name = "s3DataUpload"
  role          = aws_iam_role.iam_lambda_role.arn
  handler       = "s3DataUpload.lambda_handler"

  layers = [aws_lambda_layer_version.pyarrow_layer.arn]

  source_code_hash = data.archive_file.lambda_s3DataUpload_data.output_base64sha256

  runtime = "python3.13"

  environment {
    variables = {
      BUCKET_NAME = "${var.project_name}-${var.region}-v1"
    }
  }

  depends_on = [aws_lambda_layer_version.pyarrow_layer]
}

#Resource importation for AWS Lambda s3DataUpload, cleanTransformData and getDataFromApi
data "archive_file" "lambda_getDataFromApi_data" {
  type        = "zip"
  source_file = "${path.module}/../aws/getDataFromApi.py" # Assurez-vous que le code source est dans ce dossier
  output_path = "${path.module}/../aws/getDataFromApi.zip"
}

data "archive_file" "lambda_cleanTransformData_data" {
  type        = "zip"
  source_file = "${path.module}/../aws/cleanTransformData.py" # Assurez-vous que le code source est dans ce dossier
  output_path = "${path.module}/../aws/cleanTransformData.zip"
}

data "archive_file" "lambda_s3DataUpload_data" {
  type        = "zip"
  source_file = "${path.module}/../aws/s3DataUpload.py" # Assurez-vous que le code source est dans ce dossier
  output_path = "${path.module}/../aws/s3DataUpload.zip"
}

#Resource allocation for CloudWatch Events (EventBridge) rule to create an event every 10 minutes
resource "aws_cloudwatch_event_rule" "cloudwatch_event_10min" {
  name                = "10MinCloudWatchEventRule"
  schedule_expression = "rate(10 minutes)"
}

# Lambda layer creation
resource "null_resource" "create_lambda_layer" {
  provisioner "local-exec" {
    command = <<EOT
      mkdir -p python/lib/python3.13/site-packages
      pip install pyarrow -t python/lib/python3.13/site-packages/
      zip -r ../aws/pyarrow_layer.zip python
      rm -rf python
    EOT
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}


resource "aws_s3_bucket" "lambda_layers_bucket" {
  bucket_prefix = "lambda-layers-bucket-"
  force_destroy = true
}

resource "aws_s3_object" "upload_layers" {
  bucket     = aws_s3_bucket.lambda_layers_bucket.bucket
  key        = "pyarrow_layer.zip"
  source     = "${path.module}/../aws/pyarrow_layer.zip"
  depends_on = [null_resource.create_lambda_layer]
}

resource "aws_lambda_layer_version" "pyarrow_layer" {
  layer_name          = "pyarrow"
  compatible_runtimes = ["python3.13"]
  s3_bucket           = aws_s3_bucket.lambda_layers_bucket.bucket
  s3_key              = aws_s3_object.upload_layers.key
}



#Affectation of the event trigger to the target Step Function
# resource "aws_cloudwatch_event_target" "step_function_target" {
#   rule      = aws_cloudwatch_event_rule.cloudwatch_event_10min.name
#   target_id = "data_injection_workflow_target"
#   arn       = aws_sfn_state_machine.data_injection_workflow.arn
#   role_arn  = aws_iam_role.iam_cloudwatch_events_role.arn
# }
