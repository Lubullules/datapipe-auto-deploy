#Resource allocation for EventBridge Scheduler to create an event every 10 minutes
# resource "aws_scheduler_schedule" "step_function_scheduler" {
#   name       = "${var.project_name}-${var.env}-StepFunctionScheduler"
#   group_name = "default"

#   flexible_time_window {
#     mode = "OFF"
#   }

#   schedule_expression = "rate(1 minute)"

#   target {
#     arn      = aws_sfn_state_machine.data_injection_workflow.arn
#     role_arn = aws_iam_role.iam_scheduler_role.arn
#   }
# }