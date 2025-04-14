#Resource importation for AWS Lambda s3DataUpload, cleanTransformData and getDataFromApi
data "archive_file" "lambda_getDataFromApi_data" {
  type        = "zip"
  source_file = "${path.module}/definitions/getDataFromApi.py" # Assurez-vous que le code source est dans ce dossier
  output_path = "${path.module}/definitions/getDataFromApi.zip"
}

data "archive_file" "lambda_processData_data" {
  type        = "zip"
  source_file = "${path.module}/definitions/processData.py" # Assurez-vous que le code source est dans ce dossier
  output_path = "${path.module}/definitions/processData.zip"
}

data "archive_file" "lambda_getDataFromRedditApi_data" {
  type        = "zip"
  source_file = "${path.module}/definitions/getDataFromRedditApi.py" # Assurez-vous que le code source est dans ce dossier
  output_path = "${path.module}/definitions/getDataFromRedditApi.zip"
}