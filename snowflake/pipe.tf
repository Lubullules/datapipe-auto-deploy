resource "snowflake_file_format" "parquet_file_format" {
  name        = "PARQUET_FILE_FORMAT"
  database    = snowflake_database.database.name
  schema      = snowflake_schema.schema.name
  format_type = "PARQUET"
  compression = "SNAPPY"

  depends_on = [snowflake_grant_database_role.tf-snow-role]
}

resource "snowflake_storage_integration" "s3_integration" {
  name             = "${local.project_acronym_upper}_${local.env_capped}_S3_INTEGRATION"
  type             = "EXTERNAL_STAGE"
  storage_provider = "S3"
  enabled          = true

  storage_aws_role_arn      = data.terraform_remote_state.aws.outputs.snowpipe_role_arn
  storage_allowed_locations = ["s3://${data.terraform_remote_state.aws.outputs.s3_bucket_name}/coinlore/processed/", "s3://${data.terraform_remote_state.aws.outputs.s3_bucket_name}/reddit/processed/"]
  storage_blocked_locations = ["s3://${data.terraform_remote_state.aws.outputs.s3_bucket_name}/coinlore/raw/", "s3://${data.terraform_remote_state.aws.outputs.s3_bucket_name}/reddit/raw/"]
}

resource "snowflake_execute" "s3_integration_update" {
  execute = "ALTER STORAGE INTEGRATION ${snowflake_storage_integration.s3_integration.name} SET STORAGE_AWS_EXTERNAL_ID = '${data.terraform_remote_state.aws.outputs.snowpipe_external_id}'"
  revert  = "ALTER STORAGE INTEGRATION ${snowflake_storage_integration.s3_integration.name} UNSET STORAGE_AWS_EXTERNAL_ID"
}

# Stage & Pipe for Coinlore Data
resource "snowflake_stage" "coinlore_data" {
  name                = "COINLORE_DATA_STAGE"
  database            = snowflake_database.database.name
  schema              = snowflake_schema.schema.name
  storage_integration = snowflake_storage_integration.s3_integration.name
  url                 = "s3://${data.terraform_remote_state.aws.outputs.s3_bucket_name}/coinlore/processed/"
  file_format         = "FORMAT_NAME = ${snowflake_file_format.parquet_file_format.fully_qualified_name}"

  depends_on = [snowflake_grant_database_role.tf-snow-role, snowflake_execute.s3_integration_update]
}

resource "snowflake_pipe" "coinlore_data" {
  name              = "COINLORE_DATA_PIPE"
  database          = snowflake_database.database.name
  schema            = snowflake_schema.schema.name
  copy_statement    = "COPY INTO ${snowflake_table.coinlore.fully_qualified_name} FROM @${snowflake_stage.coinlore_data.fully_qualified_name} FILE_FORMAT = (TYPE = 'PARQUET') MATCH_BY_COLUMN_NAME = 'CASE_INSENSITIVE'"
  auto_ingest       = true
  aws_sns_topic_arn = data.terraform_remote_state.aws.outputs.sns_coinlore_topic_arn

  depends_on = [snowflake_grant_database_role.tf-snow-role]
}

# Stage & Pipe for Reddit Data

resource "snowflake_stage" "reddit_data" {
  name                = "REDDIT_DATA_STAGE"
  database            = snowflake_database.database.name
  schema              = snowflake_schema.schema.name
  storage_integration = snowflake_storage_integration.s3_integration.name
  url                 = "s3://${data.terraform_remote_state.aws.outputs.s3_bucket_name}/reddit/processed/"
  file_format         = "FORMAT_NAME = ${snowflake_file_format.parquet_file_format.fully_qualified_name}"

  depends_on = [snowflake_grant_database_role.tf-snow-role, snowflake_execute.s3_integration_update]
}

resource "snowflake_pipe" "reddit_data" {
  name              = "REDDIT_DATA_PIPE"
  database          = snowflake_database.database.name
  schema            = snowflake_schema.schema.name
  copy_statement    = "COPY INTO ${snowflake_table.reddit.fully_qualified_name} FROM @${snowflake_stage.reddit_data.fully_qualified_name} FILE_FORMAT = (TYPE = 'PARQUET') MATCH_BY_COLUMN_NAME = 'CASE_INSENSITIVE'"
  auto_ingest       = true
  aws_sns_topic_arn = data.terraform_remote_state.aws.outputs.sns_reddit_topic_arn

  depends_on = [snowflake_grant_database_role.tf-snow-role]
}