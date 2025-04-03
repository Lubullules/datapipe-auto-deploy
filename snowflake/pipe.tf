resource "snowflake_stage" "my_stage" {
  name                = "MY_STAGE"
  database            = snowflake_database.my_database.name
  schema              = snowflake_schema.my_schema.name
  storage_integration = var.my_s3_integration_name
  url                 = "s3://${data.terraform_remote_state.aws.outputs.s3_bucket_name}/processed/"
  file_format         = "FORMAT_NAME = ${snowflake_file_format.parquet_file_format.fully_qualified_name}"

  depends_on = [snowflake_grant_database_role.tf-snow-role_grant]
}

resource "snowflake_file_format" "parquet_file_format" {
  name        = "PARQUET_FILE_FORMAT"
  database    = snowflake_database.my_database.name
  schema      = snowflake_schema.my_schema.name
  format_type = "PARQUET"

  depends_on = [snowflake_grant_database_role.tf-snow-role_grant]
}

resource "snowflake_pipe" "my_pipe" {
  name           = "MY_PIPE"
  database       = snowflake_database.my_database.fully_qualified_name
  schema         = snowflake_schema.my_schema.name
  copy_statement = "COPY INTO ${snowflake_table.my_table.fully_qualified_name} FROM @${snowflake_stage.my_stage.fully_qualified_name} FILE_FORMAT = (TYPE = 'PARQUET') MATCH_BY_COLUMN_NAME = 'CASE_INSENSITIVE'"
  auto_ingest    = true

  depends_on = [snowflake_grant_database_role.tf-snow-role_grant]
}

variable "my_s3_integration_name" {
  default = "MY_S3_INTEGRATION"
}

resource "snowflake_execute" "my_s3_integration" {
  execute = "CREATE STORAGE INTEGRATION ${var.my_s3_integration_name} TYPE = EXTERNAL_STAGE STORAGE_PROVIDER = 'S3' ENABLED = TRUE STORAGE_AWS_IAM_USER_ARN = '${data.terraform_remote_state.aws.outputs.snowpipe_role_arn}' STORAGE_ALLOWED_LOCATIONS = ('s3://${data.terraform_remote_state.aws.outputs.s3_bucket_name}/processed/') STORAGE_BLOCKED_LOCATIONS = ('s3://${data.terraform_remote_state.aws.outputs.s3_bucket_name}/raw/') STORAGE_AWS_EXTERNAL_ID = '${data.terraform_remote_state.aws.outputs.snowpipe_external_id}'"
  revert  = "DROP STORAGE INTEGRATION ${var.my_s3_integration_name}"
}