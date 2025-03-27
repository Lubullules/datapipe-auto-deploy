terraform {
  required_providers {
    snowflake = {
      source = "Snowflake-Labs/snowflake"
    }
  }
}
provider "snowflake" {
  role = "SYSADMIN"
}