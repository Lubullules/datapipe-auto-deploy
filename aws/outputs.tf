output "project_name" {
  value = var.project_name
}

output "s3_bucket_name" {
  value = aws_s3_bucket.bucket.id
}

output "snowpipe_role_arn" {
  value = aws_iam_role.iam_snowpipe_role.arn
}

output "snowpipe_external_id" {
  value = random_string.snowpipe_external_id.result
}

# output s3_bucket_arn {
#   value       = aws_s3_bucket.bucket.arn
# }
