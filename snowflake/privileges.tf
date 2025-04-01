resource "snowflake_grant_privileges_to_database_role" "tf-snow-role_grant" {
    database_role_name = var.snowflake_role
    on_database = snowflake_database.my_database.name
    all_privileges = true
}