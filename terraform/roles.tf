#Role for CloudWatch Events
resource "aws_iam_role" "iam_cloudwatch_events_role" {
  name = "CloudwatchEventsRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "events.amazonaws.com"
        }
      }
    ]
  })
}