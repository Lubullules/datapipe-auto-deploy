#Resource importation for AWS Lambda s3DataUpload, cleanTransformData and getDataFromApi
data "archive_file" "lambda_getDataFromCoinloreApi_data" {
  type        = "zip"
  source_file = "${path.module}/definitions/getDataFromCoinloreApi.py" # Assurez-vous que le code source est dans ce dossier
  output_path = "${path.module}/definitions/getDataFromCoinloreApi.zip"
}

data "archive_file" "lambda_processData_data" {
  type        = "zip"
  source_file = "${path.module}/definitions/processCoinloreData.py" # Assurez-vous que le code source est dans ce dossier
  output_path = "${path.module}/definitions/processCoinloreData.zip"
}

data "archive_file" "lambda_getDataFromRedditApi_data" {
  type        = "zip"
  source_file = "${path.module}/definitions/getDataFromRedditApi.py" # Assurez-vous que le code source est dans ce dossier
  output_path = "${path.module}/definitions/getDataFromRedditApi.zip"
}