output "s3_bucket_name" {
  value = aws_s3_bucket.data_bucket.id
}

output "snowpipe_role_arn" {
  value = aws_iam_role.snowpipe.arn
}

output "snowpipe_external_id" {
  value = random_string.snowpipe_external_id.result
}

output "sns_coinlore_topic_arn" {
  value = aws_sns_topic.snowpipe_coinlore.arn
}

output "sns_reddit_topic_arn" {
  value = aws_sns_topic.snowpipe_reddit.arn
}