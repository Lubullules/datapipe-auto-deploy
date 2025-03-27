#Resource importation for AWS Lambda s3DataUpload, cleanTransformData and getDataFromApi
data "archive_file" "lambda_getDataFromApi_data" {
  type        = "zip"
  source_file = "aws/definitions/getDataFromApi.py" # Assurez-vous que le code source est dans ce dossier
  output_path = "aws/definitions/getDataFromApi.zip"
}

data "archive_file" "lambda_processData_data" {
  type        = "zip"
  source_file = "aws/definitions/processData.py" # Assurez-vous que le code source est dans ce dossier
  output_path = "aws/definitions/processData.zip"
}