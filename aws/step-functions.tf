resource "aws_sfn_state_machine" "data_injection_workflow" {
  name     = "${local.project_acronym_lower}-${var.env}-dataInjectionWorkflow"
  role_arn = aws_iam_role.step_function.arn

  definition = templatefile("${path.module}/definitions/DataInjectionWorkflow.asl.json", {
    get_data_from_coinlore_api_arn = aws_lambda_function.getDataFromCoinloreApi.arn,
    process_coinlore_data_arn      = aws_lambda_function.processCoinloreData.arn,
    get_data_from_reddit_api_arn   = aws_lambda_function.getDataFromRedditApi.arn,
    process_reddit_data_arn        = aws_lambda_function.processRedditData.arn,
  })

  type = "STANDARD"
}
