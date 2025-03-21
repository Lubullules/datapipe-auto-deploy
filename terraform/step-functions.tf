#Resource allocation for Step Function
resource "aws_sfn_state_machine" "data_injection_workflow" {
  name       = "DataInjectionWorkflow"
  role_arn   = aws_iam_role.iam_sfn_role.arn
  definition = file("${path.module}/../aws/DataInjectionWorkflow.asl.json")

  type = "STANDARD"
}