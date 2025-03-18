resource "aws_s3_bucket" "bucket" {
  bucket = "${var.project_name}-${var.region}-v1"
}

#Resource allocation for CloudWatch Events (EventBridge) rule to create an event every 10 minutes
resource "aws_cloudwatch_event_rule" "cloudwatch_event_10min"{
  name = "10MinCloudWatchEventRule"
  schedule_expression = "rate(10minutes)"
}

#Affectation of the event trigger to the target Step Function
resource "aws_cloudwatch_event_target" "step_function_target" {
  rule      = aws_cloudwatch_event_rule.cloudwatch_event_10min
  target_id = "data_injection_workflow_target"
  arn       = aws_sfn_state_machine.data_injection_workflow.arn
  role_arn  = aws_iam_role.cloudwatch_events_role.arn
} 
