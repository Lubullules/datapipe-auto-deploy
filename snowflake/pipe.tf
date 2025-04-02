resource "snowflake_stage" "my_stage" {
  name                = "MY_STAGE"
  database            = snowflake_database.my_database.name
  schema              = snowflake_schema.my_schema.name
  storage_integration = snowflake_storage_integration.my_s3_integration.name
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
  schema         = snowflake_schema.my_schema.fully_qualified_name
  copy_statement = "COPY INTO ${snowflake_table.my_table.fully_qualified_name} FROM @${snowflake_stage.my_stage.fully_qualified_name}"
  auto_ingest    = true

  depends_on = [snowflake_grant_database_role.tf-snow-role_grant]
}


resource "snowflake_storage_integration" "my_s3_integration" {
  name    = "MY_S3_INTEGRATION"
  type    = "EXTERNAL_STAGE"
  enabled = true

  storage_provider          = "S3"
  storage_aws_role_arn      = data.terraform_remote_state.aws.outputs.snowpipe_role_arn
  storage_allowed_locations = ["s3://${data.terraform_remote_state.aws.outputs.s3_bucket_name}/processed/"]
}