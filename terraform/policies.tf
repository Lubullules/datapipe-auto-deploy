#Create policy for CloudWatch Events
resource "aws_iam_policy" "cwe_sfn_policy" {
    name = "CloudWatchEventsStartStepFunctionExecutionPolicy"
    policy = jsonencode({
        "Version" = "2012-10-17",
        "Statement" = [
            {
                "Effect" = "Allow",
                "Action" = [
                    "states:StartExecution"
                    ],
                "Resource" = "${aws_sfn_state_machine.data_injection_workflow.arn}"
            }
        ]
    })
}

#Attach policy for CloudWatch Events
resource "aws_iam_role_policy_attachment" "cwe_policy_attachment" {
    role = aws_iam_role.iam_cloudwatch_events_role.name
    policy_arn = aws_iam_policy.cwe_sfn_policy.arn
}
