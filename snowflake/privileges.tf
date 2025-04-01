resource "snowflake_database_role" "tf-snow-db-role" {
  name     = "${var.snowflake_role}-DB"
  database = snowflake_database.my_database.name
}

resource "snowflake_grant_privileges_to_database_role" "tf-snow-db-role_grant" {
  database_role_name = "${snowflake_database.my_database.name}.${snowflake_database_role.tf-snow-db-role.name}"
  on_database        = snowflake_database.my_database.name
  all_privileges     = true
}

resource "snowflake_grant_database_role" "tf-snow-role_grant" {
  database_role_name = "${snowflake_database.my_database.name}.${snowflake_database_role.tf-snow-db-role.name}"
  parent_role_name   = var.snowflake_role
}