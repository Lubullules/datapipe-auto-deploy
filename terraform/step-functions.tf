resource "aws_sfn_state_machine" "data_injection_workflow" {
  name     = "${var.project_name}-${var.env}-dataInjectionWorkflow"
  role_arn = aws_iam_role.iam_sfn_role.arn
  definition = templatefile("${path.module}/../aws/DataInjectionWorkflow.asl.json", {
    get_data_from_api_arn    = aws_lambda_function.lambda_getDataFromApi_resource.arn,
    clean_transform_data_arn = aws_lambda_function.lambda_cleanTransformData_resource.arn,
    s3_data_upload_arn       = aws_lambda_function.lambda_s3DataUpload_resource.arn
  })

  type = "STANDARD"
}
