resource "snowflake_query" "switch_warehouses" {
  statement = "USE WAREHOUSE ${snowflake_warehouse.my_warehouse.name};"

  depends_on = [snowflake_warehouse.my_warehouse]
}