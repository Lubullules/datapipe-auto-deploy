
# 📊 finance-DE-lab

## 🎯 Data Engineering Project - Hands-on Training  

**Objective:** Develop a complete data pipeline for collection, transformation, and visualization to build expertise in **AWS, Snowflake, GitHub Actions, and Terraform**.

---

## User Guide

### 🛠️ Prerequisites

- **AWS Account**: Access to AWS resources
  - Create a new IAM user with administrator access
  - Create a S3 bucket that will serve as the backend for Terraform and the logs of the data bucket
- **Snowflake Account**: Access to Snowflake resources
  - Run the SQL script `snowflake/setup.sql` as `ACCOUNT_ADMIN` to create a user and a role for the project
  - The script will create a dummy storage integration for the purpose of retrieving the AWS user associated with your Snowflake account, store this value (if you missed it, go check in the query history)
  - Create a key pair for the Snowflake user
- **Reddit Account**: Access to Reddit API
  - Create a Reddit account
  - Create a Reddit app to get the client ID and secret [here](https://www.reddit.com/prefs/apps)
  
### For Local Deployment

- **Terraform**: Install Terraform CLI
- **Docker**: Install Docker
- **AWS CLI**: Install AWS CLI and configure with the credentials of the IAM user created in the prerequisites

- **Variables**: Fill in the `.local/.env.local` file with the corresponding values
- **Scripts**: Run the `.local/terraform.sh` script to deploy the infrastructure locally or the `.local/terraform-destroy.sh` script to destroy the infrastructure locally

### For deployment with Github Actions

- **GitHub Repository**: Create a new GitHub repository, push the code to it and enable GitHub Actions in your repository

- **Workflows**: The workflows are located in the `.github/workflows` folder. The `terraform.yml` workflow is used to deploy the infrastructure and the `terraform-destroy.yml` workflow is used to destroy the infrastructure. There are 2 manual approval steps for both workflows

- **Personal Access Token**: Create a personal access token as shown [here](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) with the `repo` scope. It will be used to write issues in the repository for the manual approval steps

- **Secrets**: Create the following secrets in your GitHub repository:
  - `AWS_ACCESS_KEY_ID`: AWS access key ID
  - `AWS_SECRET_ACCESS_KEY`: AWS secret access key
  - `SNOWFLAKE_PRIVATE_KEY`: Snowflake private key (base64 encoded)
  - `SNOWFLAKE_AWS_USER_ARN`: ARN of the AWS user associated with your Snowflake account
  - `REDDIT_USERNAME`: Reddit username
  - `REDDIT_PASSWORD`: Reddit password
  - `REDDIT_CLIENT_ID`: Reddit client ID
  - `REDDIT_CLIENT_SECRET`: Reddit client secret
  - `ISSUE_WRITING_TOKEN`: Token for writing issues to the repository (for manual approval steps)

- **Variables**: Create the following variables in your GitHub repository:
  - `PROJECT_NAME`: Name of the project (kebab-case)
  - `APPROVERS`: List of GitHub usernames of the approvers for the manual approval steps
  - `TF_STATE_BASE_BUCKET`: Name of the S3 bucket for the Terraform state (kebab-case, must be unique in the region, test in local before)
  - `AWS_REGION`: AWS region
  - `AWS_ACCOUNT_ID`: AWS account ID
  - `SNOWFLAKE_ORG_NAME`: Snowflake organization name
  - `SNOWFLAKE_ACCOUNT_NAME`: Snowflake account name

---

## 🗺️ Architecture & Technologies  

### 📡 Data Flow  

1. **Collection:** Retrieve raw data from public APIs  
2. **Transformation:** AWS Lambda + Step Functions  
3. **Storage:** Parquet files on S3, ingestion via Snowpipe  
4. **Exposure:** Final Snowflake schema for analysis  
5. **Visualization:** Tableau or other BI tools  
6. **Deployment & Automation:** Terraform + GitHub Actions  

---

## 📦 Project Organization  

| Folder                  | Description                                      |
|:------------------------|:-------------------------------------------------|
| `.github/workflows/`     | CI/CD pipelines for Terraform & DBT             |
| `.local/`                | Local config for dev & test                     |
| `aws/`                   | AWS resources & configurations                  |
| `snowflake/`             | Snowflake resources & configurations             |

### 📁 aws/ folder  

- `backend.tf` : Terraform backend configuration  
- `lambda.tf` : Lambda function configurations  
- `step-functions.tf` : Step Functions definitions  
- `s3.tf` : S3 bucket configuration  
- `event-bridge.tf` : Event scheduling via EventBridge  
- `iam.tf` : IAM roles and policies  
- `sns.tf` : SNS topic setup  
- `ecr-repo.tf` : ECR repository  

### 📁 snowflake/ folder  

- `snowflake.tf` : Schemas and table creation  
- `pipe.tf` : Snowpipe configuration  
- `privileges.tf` : Access control policies  
- `remote-state.tf` : Terraform remote state  

### 🌐 Environments  

- **dev**  
- **prod**  

Each environment has its own Snowflake schema and AWS resources.

---

## 🔄 Pipeline Details  

### 📥 Data Collection  

| Public API              | Data Format | Authentication | Content Type |
|:------------------------|:------------|:---------------|
| [Coinlore](https://www.coinlore.com/cryptocurrency-data-api) | JSON | No auth | Data on the Top 1000 cryptocurrencies by market cap |
| [Reddit API](https://www.reddit.com/dev/api/) | JSON | Account Credentials + API Token | Last 50 Posts from r/cryptocurrency

- **Retrieval Frequency**: Every 10 minutes
- **Storage Format:** Parquet
- **Partitioning:** `timestamp=YYYY-MM-DDTHH:MM:SS.000Z`

---

### 🧹 Data Processing (ETL)

- **Technologies:** AWS Step Function orchestrating Python Lambdas
- **Libraries:** `pandas`, `nltk`, `awswrangler`
- **Transformations Applied:**
  - Added timestamps
  - Removed irrelevant columns
  - Handled null values
  - On Reddit Data:
    - Cross-reference with Coinlore list of cryptocurrencies
    - Detection of cryptocurrency mentions in texts and titles
    - Sentiment analysis on titles and texts, scoring from -1 to 1
    - Count of mentions per cryptocurrency
    - Average sentiment score per cryptocurrency
  

---

### ⬆️ Ingestion into Snowflake  

- **Snowpipe:** Automatic ingestion from S3  
- **Schemas:** 
  - `LOADING`: Raw data
  - `STAGING`: Work in progress
  - `WORKING`: Data ready for exposure
- **Policy:** Append-only with timestamp  

---

### 📊 Visualization (Tableau)

- Direct Snowflake connection  
- Dynamic dashboards  
- Role-based access control  

---

## 🚀 Deployment & Automation  

- **Infrastructure as Code:** Terraform  
- AWS and Snowflake provisioning  
- CI/CD via GitHub Actions or local bash scripts
- **Monitoring:**
  - AWS CloudWatch for logs of Lambda functions
  - Snowflake: Query history and task history

---

## TODO

### v1.x

- [ ] Trigger rebuild of the docker image when changes to the py func or dockerfile
- [ ] Use of Terraform modules and overall refactoring
- [ ] Rewrite and refactor the Lambda functions
- [ ] Error handling in the Lambda functions
- [ ] Variabilisation of the layers used in the Lambda functions because of region-lock
- [ ] Explicitly declare the AWS credentials in the local config

### v2

- [ ] Add data sources on the text side (other subreddits...)

#### Data Engineering

- [ ] Use other methods to extract and load data (AWS Glue, AWS Data Pipeline, AWS Batch)
- [ ] Compare performance of different methods

#### Data Science

- [ ] Improve the recognition of cryptocurrency names and tickers in texts with Named Entity Recognition (NER) and/or other NLP techniques
- [ ] Use of more advanced sentiment analysis techniques (e.g. BERT, RoBERTa, etc.)

#### Data Analysis

- [ ] More visualisations on the data
- [ ] Use of Grafana to visualise the data in a IaC environment

## 🛠️ Troubleshooting  

### 📌 Topic Subscription Issue  

When an SNS topic is deleted, Snowpipe stops loading files.  
**Fix:** Create a new topic with a different name and re-run the Snowpipe.

**Useful Links:**

- [Snowpipe SNS Config](https://docs.snowflake.com/en/user-guide/data-load-snowpipe-ts)
- [AWS Cross-account SNS Subscriptions](https://repost.aws/knowledge-center/sns-cross-account-subscription)

### 📌 Debugging Snowpipe  

```sql
SELECT SYSTEM$PIPE_STATUS('<MY_DATABASE.MY_SCHEMA.MY_PIPE>');
```

Check pipe status and any load errors.

[Official Snowpipe Debug Guide](https://docs.snowflake.com/fr/user-guide/data-load-snowpipe-ts#step-1-check-the-pipe-status)

---

## ✍️ Personal Reflections  

### 🛡️ Security

  A whole lot of permissions are broadly given, we should carefully analyse and maybe reduce the scope of the permissions given to the roles managed by Terraform.
  We have not looked at the security of the data in transit and at rest (bucket encryption...). Our data is not sensitive but we should have a look at it.

### ⚙️ Issues Faced  

- **AWS SNS**: Deleted topics’ names are locked for 72h → workaround: dynamic prefixes.
- **Terraform**: Can’t define multiple bucket events across separate TF resources → merge into a single resource.
- **Snowpipe SQS Collisions**: Single SQS queue for multiple Snowpipes causes conflicts → one topic per pipe.

---

## 📖 Naming Conventions  

| Element            | Convention                                 |
|:------------------|:-------------------------------------------|
| **Terraform**       | `snake_case`, project and env prefix       |
| **AWS - S3**        | `kebab-case`, project-env-region           |
| **AWS - IAM/EB**    | `PascalCase`, ProjectEnvResource           |
| **Other AWS**       | `kebab-case`, project-env-resource         |
| **Snowflake**       | `UPPER_SNAKE_CASE`, PROJECT_ENV_RESOURCE   |

---

## 📊 Suggestions for Improvement  

- 👉 Add **architecture diagrams** (replace Mermaid with images or external tools)
- 👉 Integrate **CloudWatch and Snowpipe metrics graphs**
- 👉 Include **Tableau dashboard screenshots**
