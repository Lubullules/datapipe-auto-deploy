terraform {
  required_providers {
    snowflake = {
      source  = "snowflakedb/snowflake"
      version = "~> 1.0.5"
    }
  }
}

provider "snowflake" {
  organization_name = var.snowflake_org_name
  account_name      = var.snowflake_account_name
  user              = var.snowflake_user
  authenticator     = "SNOWFLAKE_JWT"
  private_key       = var.snowflake_private_key
  role              = var.snowflake_role

  preview_features_enabled = ["snowflake_table_resource", "snowflake_file_format_resource", "snowflake_storage_integration_resource", "snowflake_stage_resource", "snowflake_pipe_resource"]
}