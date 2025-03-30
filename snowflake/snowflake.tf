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
