resource "snowflake_warehouse" "my_warehouse" {
  name           = "MY_WAREHOUSE"
  warehouse_size = "XSMALL"
  auto_suspend   = 60
  auto_resume    = true
}

resource "snowflake_database" "my_database" {
  name = "MY_DATABASE"
}

resource "snowflake_schema" "my_schema" {
  name     = "MY_SCHEMA"
  database = snowflake_database.my_database.name
}

resource "snowflake_table" "my_table" {
  name     = "MY_TABLE"
  database = snowflake_database.my_database.name
  schema   = snowflake_schema.my_schema.name

  column {
    name = "id"
    type = "NUMBER"
  }

  column {
    name = "name"
    type = "STRING"
  }

  column {
    name = "created_at"
    type = "TIMESTAMP"
  }
}

resource "snowflake_storage_integration" "my_s3_integration" {
  name        = "MY_S3_INTEGRATION"
  type        = "EXTERNAL_STAGE"
  enabled     = true

  storage_provider         = "S3"
  storage_aws_role_arn     = "<ARN_ROLE_AWS>"
  storage_allowed_locations = ["s3://${aws_s3_bucket.bucket}/processed/"]
}

resource "snowflake_stage" "my_stage" {
  name                = "MY_STAGE"
  database            = snowflake_database.my_database.name
  schema              = snowflake_schema.my_schema.name
  storage_integration = snowflake_storage_integration.my_s3_integration.name
  url                 = "s3://${aws_s3_bucket.bucket}/processed/"
  file_format         = "PARQUET"
}

resource "snowflake_pipe" "my_pipe" {
  name        = "MY_PIPE"
  database    = snowflake_database.my_database.name
  schema      = snowflake_schema.my_schema.name
  stage       = snowflake_stage.my_stage.name
  warehouse   = snowflake_warehouse.my_warehouse.name
  copy_statement = "COPY INTO MY_TABLE FROM @MY_STAGE FILE_FORMAT = (TYPE = 'PARQUET')"
  auto_ingest    = true
}
