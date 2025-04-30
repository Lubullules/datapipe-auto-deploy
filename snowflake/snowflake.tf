resource "snowflake_warehouse" "warehouse" {
  name           = "${local.project_acronym_upper}_${local.env_capped}_WAREHOUSE"
  warehouse_size = "XSMALL"
  auto_suspend   = 60
  auto_resume    = true
}

resource "snowflake_database" "database" {
  name = "${local.project_acronym_upper}_${local.env_capped}_DATABASE"
}

resource "snowflake_schema" "schema" {
  name       = "${local.project_acronym_upper}_${local.env_capped}_SCHEMA"
  database   = snowflake_database.database.name
  depends_on = [snowflake_grant_database_role.tf-snow-role]
}

resource "snowflake_table" "coinlore" {
  name     = "${local.project_acronym_upper}_${local.env_capped}_COINLORE_TABLE"
  database = snowflake_database.database.name
  schema   = snowflake_schema.schema.name

  depends_on = [snowflake_grant_database_role.tf-snow-role]

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
    name = "pipeline_timestamp"
    type = "TIMESTAMP_TZ"
  }
}

resource "snowflake_table" "reddit" {
  name     = "${local.project_acronym_upper}_${local.env_capped}_REDDIT_TABLE"
  database = snowflake_database.database.name
  schema   = snowflake_schema.schema.name

  depends_on = [snowflake_grant_database_role.tf-snow-role]

  column {
    name = "id"
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
    name = "count"
    type = "INTEGER"
  }

  column {
    name = "average_sentiment"
    type = "FLOAT"
  }

  column {
    name = "pipeline_timestamp"
    type = "TIMESTAMP_TZ"
  }
}