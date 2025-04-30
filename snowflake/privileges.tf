resource "snowflake_database_role" "tf-snow-role-db" {
  name     = "${local.env_capped}-${var.snowflake_role}-DB"
  database = snowflake_database.database.name
}

resource "snowflake_grant_privileges_to_database_role" "tf-snow-role-db" {
  database_role_name = "${snowflake_database.database.name}.${snowflake_database_role.tf-snow-role-db.name}"
  on_database        = snowflake_database.database.name
  all_privileges     = true
}

resource "snowflake_grant_database_role" "tf-snow-role" {
  database_role_name = "${snowflake_database.database.name}.${snowflake_database_role.tf-snow-role-db.name}"
  parent_role_name   = var.snowflake_role

  depends_on = [snowflake_grant_privileges_to_database_role.tf-snow-role-db]
}