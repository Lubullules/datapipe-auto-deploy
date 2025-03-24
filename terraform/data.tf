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