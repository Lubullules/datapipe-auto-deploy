terraform {
  required_providers {
    snowflake = {
      source = "Snowflake-Labs/snowflake"
    }
  }
}
provider "snowflake" {
  role = "ACCOUNTADMIN"
  organization_name = "JLWJSHF"
  account_name = "BJ18758"
  user = "TF-SNOW"
  authenticator = "SNOWFLAKE_JWT"
  private_key = "${file("~/.ssh/snowflake_tf_snow_key.p8")}"
}