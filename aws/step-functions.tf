resource "aws_sfn_state_machine" "data_injection_workflow" {
  name     = "${var.project_name}-${var.env}-dataInjectionWorkflow"
  role_arn = aws_iam_role.iam_sfn_role.arn
  definition = templatefile("${path.module}/definitions/DataInjectionWorkflow.asl.json", {
    get_data_from_api_arn        = aws_lambda_function.lambda_getDataFromApi_resource.arn,
    process_data_arn             = aws_lambda_function.lambda_processData_resource.arn,
    get_data_from_reddit_api_arn = aws_lambda_function.lambda_getDataFromRedditApi_resource.arn,
    process_reddit_data_arn      = aws_lambda_function.lambda_processRedditData_resource.arn,
  })

  type = "STANDARD"
}
