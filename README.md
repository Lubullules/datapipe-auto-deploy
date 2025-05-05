#### finance-DE-lab

# Data Engineering Project - Hands-on Training

*Objective: Develop a complete data pipeline for collection, transformation, and visualization to gain expertise in AWS, Snowflake, Github Actions and Terraform.*

⸻

### 1. Architecture and Technologies


#### Data Flow

1. **Collection**: Retrieve raw data from public APIs.
2. **Transformation & Cleaning**: Process data using AWS Step Functions and Lambda.
3. **Storage & Ingestion**: Store cleaned data in an S3 bucket and ingest it into Snowflake via Snowpipe.
4. **Data Exposure**: A final schema (exposed) consolidates data ready for analysis.
5. **Visualization**: Create dashboards using Tableau or other data vizualisation tools.
6. **Deployment & Automation**: Use Terraform to manage AWS and Snowflake, with GitHub for source code. Deployement is automated using GitHub Actions.

⸻

### 2. Project Organization

- **Mono-repository GitHub**: A single structured repo with dedicated folders:
  - `.github/workflows/` → CI/CD pipelines for Terraform and DBT
  - `.local/` → Local configuration files for development and testing
  - `aws/` → Contains all AWS resources and configurations
    - `.config/` → Specification on which environment to deploy
    - `definitions/` → Code source for lambdas and definition of step functions
    - `backend.tf` → Terraform backend configuration
    - `data.tf` → Terraform data sources for AWS resources
    - `docker.tf` → Command to build and push Docker images to ECR
    - `ecr-repo.tf` → Terraform ECR repository configuration
    - `event-bridge.tf` → EventBridge rules for scheduling
    - `iam.tf` → IAM roles and policies for AWS resources
    - `lambda.tf` → Lambda function configuration
    - `output.tf` → Terraform output variables
    - `provider.tf` → AWS provider configuration
    - `s3.tf` → S3 bucket configuration
    - `sns.tf` → SNS topic configuration
    - `step-functions.tf` → Step Functions configuration
    - `variables.tf` → Terraform input variables
  - `snowflake/` → Contains all Snowflake resources and configurations
    - `.config/` → Specification on which environment to deploy
    - `backend.tf` → Snowflake backend configuration
    - `pipe.tf` → Snowpipe configuration
    - `privileges.tf` → Snowflake privileges configuration
    - `providers.tf` → Snowflake provider configuration
    - `remote-state.tf` → Remote state configuration for Snowflake
    - `snowflake.tf` → Snowflake resources configuration
    - `variables.tf` → Snowflake input variables
- **Environments**: Dev and Prod are separated, each with its own Snowflake schema and dedicated AWS resources.

⸻

### 3. Pipeline Details

#### Data Collection

- **Selected public API**: [Coinlore](https://www.coinlore.com/cryptocurrency-data-api) and [Reddit API](https://www.reddit.com/dev/api/)
- **Data format**: JSON and parquet
- **Authentication**: API key stored in GitHub secrets
- **Frequency**: 10min extraction using AWS EventBridge + Lambda

#### Data Processing & Cleaning (ETL)

- **Technologies**: AWS Step Functions in Jsonata orchestrating Lambdas and python with use of pandas, nltk and awswrangler
- **Applied transformations**:
  - Added unique timestamps for each record and for each API call
  - Removing unnecessary columns
  - Checking for null values
  - Snetiment analysis on Reddit comments using NLTK
- **Storage in S3**:
  - **Format**: Parquet
  - **Partitioning**: `year=/month=/day=`
  - **File naming convention**: `dataset_YYYYMMDD_HHMM.parquet`

#### Ingestion into Snowflake

- **Snowpipe** for automatic ingestion when a file arrives in S3
- **Loading schema** to store raw data
- **Ingestion policy**: Append-only with timestamp

#### Visualization with Tableau

- Direct connection to Snowflake
- Dynamic dashboard creation
- Role-based access management and sharing

⸻

### 4. Deployment & Automation

- **Infrastructure as Code with Terraform**
- **AWS resource provisioning** (Lambda, Step Functions, S3, Snowpipe)
- **Snowflake schema and table configuration**
- **Monitoring & Alerting**:
  - **Logs**: CloudWatch for Step Functions and Lambda
  - **Alerts**: AWS SNS for failure notifications
  - **Snowpipe tracking**: File ingestion verification

  ---------------------------------------------------------------

# Troubleshooting

**Topic subription issue:** If you encounter the topic subription issue, please note that Snowpipe stops loading files after Amazon SNS topic subscription is deleted. To resolve this, you need to re-create the subscription with another name and re-run the Snowpipe. This is a known issue with Snowpipe and SNS integration. 

  ##### Useful links:
  - https://docs.snowflake.com/en/user-guide/data-load-snowpipe-ts
  - https://repost.aws/knowledge-center/sns-cross-account-subscription

**Snowpipe debugging :** If you encounter issues with Snowpipe, you can use the following SQL command to check the status of your Snowpipe and identify any errors that may have occurred during the loading process:
```sql
SELECT SYSTEM$PIPE_STATUS('<MY_DATABASE.MY_SCHEMA.MY_PIPE>');
```
- This command will provide you with information about the status of your Snowpipe, including any errors that may have occurred during the loading process. You can use this information to troubleshoot and resolve any issues you may be experiencing.
- For more information on Snowpipe debugging, you can refer to the official Snowflake documentation: [Snowpipe Debugging](https://docs.snowflake.com/fr/user-guide/data-load-snowpipe-ts#step-1-check-the-pipe-status).


  ---------------------------------------------------------------

# Personal reflections

## Problems with Interfacing AWS and Snowflake
 AWS puts a timer of 72h when deleting a topic and thus the name of the topic is not available for 72h. This is a problem when you want to delete and recreate the topic with the same name when making deployment tests -> fixed by using prefixes in the topic name.
 Terraform does not allow to create two different notification events for the same bucket. You have to add each event in the same TF object.
 There is a collision when multiple Snowpipes are subscribed to the same topic since Snowflake uses a single SQS queue for all Snowpipes. This is a problem when you want to use the same topic for multiple Snowpipes. -> fixed by using different topics for each Snowpipe.

# Naming conventions

Terraform objects:
    ne pas repéter le type de ressource dans le nom
    snake_case

AWS objects:
    Bucket S3: kebab-case, projet(forme longue)-env-region, à voir si besoin de préfixe
    IAM & EventBridge: PascalCase, Projet(forme courte)EnvRessource
    Autres: kebab-case, projet(forme courte)-env-ressource

Snowflake objects:
    MAJ_SNAKE_CASE, PROJET(forme courte)_ENV_RESSOURCE
