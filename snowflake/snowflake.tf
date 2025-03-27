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
    type = "STRING"
  }

  column {
    name = "symbol"
    type = "STRING"
  }

  column {
    name = "name"
    type = "STRING"
  }

  column {
    name = "nameid"
    type = "STRING"
  }

  column {
    name = "price_usd"
    type = "FLOAT"
  }

  column {
    name = "percent_change_1h"
    type = "FLOAT"
  }

  column {
    name = "percent_change_24h"
    type = "FLOAT"
  }

  column {
    name = "percent_change_7d"
    type = "FLOAT"
  }

  column {
    name = "price_btc"
    type = "FLOAT"
  }

  column {
    name = "market_cap_usd"
    type = "FLOAT"
  }

  column {
    name = "volume24"
    type = "FLOAT"
  }

  column {
    name = "volume24a"
    type = "FLOAT"
  }

  column {
    name = "csupply"
    type = "FLOAT"
  }

  column {
    name = "tsupply"
    type = "FLOAT"
  }

  column {
    name = "msupply"
    type = "FLOAT"
  }

  column {
    name = "wf_timestamp"
    type = "TIMESTAMP_TZ"
  }
}


resource "snowflake_stage" "my_stage" {
  name                = "MY_STAGE"
  database            = snowflake_database.my_database.name
  schema              = snowflake_schema.my_schema.name
  storage_integration = snowflake_storage_integration.my_s3_integration.name
  url = "s3://${data.aws_s3_bucket.existing_bucket.id}/processed/"
  file_format         = snowflake_file_format.parquet_file_format.name
}

resource "snowflake_file_format" "parquet_file_format" {
  name        = "PARQUET_FILE_FORMAT"
  database    = snowflake_database.my_database.name
  schema      = snowflake_schema.my_schema.name
  format_type = "PARQUET"
}

resource "snowflake_pipe" "my_pipe" {
  name        = "MY_PIPE"
  database    = snowflake_database.my_database.name
  schema      = snowflake_schema.my_schema.name
  copy_statement = "COPY INTO ${snowflake_table.my_table.name} FROM @${snowflake_stage.my_stage.name}"
  auto_ingest    = true
}


resource "snowflake_storage_integration" "my_s3_integration" {
  name        = "MY_S3_INTEGRATION"
  type        = "EXTERNAL_STAGE"
  enabled     = true

  storage_provider         = "S3"
  storage_aws_role_arn     = "<ARN_ROLE_AWS>"
  storage_allowed_locations = ["s3://${data.terraform_remote_state.aws.outputs.bucket_name}/processed/"]
}