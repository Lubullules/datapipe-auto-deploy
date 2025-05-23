#Resource importation for AWS Lambda s3DataUpload, cleanTransformData and getDataFromApi
data "archive_file" "getDataFromCoinloreApi_source" {
  type        = "zip"
  source_file = "${path.module}/definitions/getDataFromCoinloreApi.py" # Assurez-vous que le code source est dans ce dossier
  output_path = "${path.module}/definitions/getDataFromCoinloreApi.zip"
}

data "archive_file" "processCoinloreData_source" {
  type        = "zip"
  source_file = "${path.module}/definitions/processCoinloreData.py" # Assurez-vous que le code source est dans ce dossier
  output_path = "${path.module}/definitions/processCoinloreData.zip"
}

data "archive_file" "getDataFromRedditApi_source" {
  type        = "zip"
  source_file = "${path.module}/definitions/getDataFromRedditApi.py" # Assurez-vous que le code source est dans ce dossier
  output_path = "${path.module}/definitions/getDataFromRedditApi.zip"
}