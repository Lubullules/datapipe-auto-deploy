data "archive_file" "lambda" {
  type        = "zip"
  source_file  = "${path.module}/src/lambda_function.py" # Assurez-vous que le code source est dans ce dossier
  output_path = "${path.module}/getDataFromAPI.zip"
}

