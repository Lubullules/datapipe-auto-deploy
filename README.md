#### finance-DE-lab

# Data Engineering Project - Hands-on Training

*Objective: Develop a complete data pipeline for collection, transformation, and visualization to gain expertise in AWS, Snowflake, DBT, and Terraform.*

⸻

### 1. Architecture and Technologies


#### Data Flow

1. **Collection**: Retrieve raw data from a public API.
2. **Transformation & Cleaning**: Process data using AWS Step Functions, Lambda, and Jsonata.
3. **Storage & Ingestion**: Store cleaned data in an S3 bucket and ingest it into Snowflake via Snowpipe.
4. **Advanced Transformation**: DBT transforms data between landing and staging schemas.
5. **Data Exposure**: A final schema (exposed) consolidates data ready for analysis.
6. **Visualization**: Create dashboards using Tableau.
7. **Deployment & Automation**: Use Terraform to manage AWS and Snowflake, with GitHub for source code.

⸻

### 2. Project Organization

- **Mono-repository GitHub**: A single structured repo with dedicated folders:
  - `terraform/` → AWS and Snowflake infrastructure
  - `etl/` → Lambda and Step Functions code
  - `dbt/` → DBT transformation projects
  - `tableau/` → Workbooks and data sources
- **Environments**: Dev and Prod are separated, each with its own Snowflake schema and dedicated AWS resources.

⸻

### 3. Pipeline Details

#### Data Collection

- **Selected public API**: [To be defined, e.g., OpenWeather, CoinGecko]
- **Data format**: JSON
- **Authentication**: API key stored in AWS Secrets Manager
- **Frequency**: Hourly extraction using AWS EventBridge + Lambda

#### Data Processing & Cleaning (ETL)

- **Technologies**: AWS Step Functions orchestrating Lambdas with Jsonata
- **Applied transformations**:
  - Removing unnecessary columns
  - Normalizing date formats
  - Filtering out outliers
  - Checking for null values
- **Storage in S3**:
  - **Format**: Parquet
  - **Partitioning**: `year=/month=/day=`
  - **File naming convention**: `dataset_YYYYMMDD_HHMM.parquet`

#### Ingestion into Snowflake

- **Snowpipe** for automatic ingestion when a file arrives in S3
- **Landing schema** to store raw data
- **Ingestion policy**: Append-only with timestamp

#### Transformation with DBT

- **Staging schema**:
  - Data type normalization
  - Deduplication and primary key management
  - Adding metadata (ingestion date, source)
- **Exposed schema**:
  - Aggregations and key metrics
  - DBT models with materialized views
  - User access management
  - Data quality testing
  - **DBT tests** (not null, unique, accepted values)
  - **DBT snapshots** to track changes

#### Visualization with Tableau

- Direct connection to Snowflake
- Dynamic dashboard creation
- Role-based access management and sharing

⸻

### 4. Deployment & Automation

- **Infrastructure as Code with Terraform**
- **AWS resource provisioning** (Lambda, Step Functions, S3, Snowpipe)
- **Snowflake schema and table configuration**
- **DBT deployment in Snowflake**
- **Monitoring & Alerting**:
  - **Logs**: CloudWatch for Step Functions and Lambda
  - **Alerts**: AWS SNS for failure notifications
  - **Snowpipe tracking**: File ingestion verification
