
# 📊 finance-DE-lab

## 🎯 Data Engineering Project - Hands-on Training  

**Objective:** Develop a complete data pipeline for collection, transformation, and visualization to build expertise in **AWS, Snowflake, GitHub Actions, and Terraform**.

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

| Public API              | Data Format | Authentication | Frequency |
|:------------------------|:------------|:----------------|:------------|
| [Coinlore](https://www.coinlore.com/cryptocurrency-data-api) | JSON | GitHub Secrets | 10 min |
| [Reddit API](https://www.reddit.com/dev/api/) | JSON | GitHub Secrets | 10 min |

- **Storage Format:** Parquet  
- **Partitioning:** `year=/month=/day=`  

---

### 🧹 Data Processing (ETL)

- **Technologies:** AWS Step Functions orchestrating Python Lambdas
- **Libraries:** `pandas`, `nltk`, `awswrangler`
- **Transformations Applied:**
  - Added timestamps
  - Removed irrelevant columns
  - Handled null values
  - Performed Reddit comment sentiment analysis with NLTK
- **File naming:** `dataset_YYYYMMDD_HHMM.parquet`

---

### ⬆️ Ingestion into Snowflake  

- **Snowpipe:** Automatic ingestion from S3  
- **Schema:** Raw → Exposed  
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
- CI/CD via GitHub Actions  
- **Monitoring:**
  - Logs: CloudWatch
  - Notifications: SNS
  - Snowpipe status tracking  

---

## TODO

### v1.x

- [ ] Trigger rebuild of the docker image when changes to the py func or dockerfile
- [ ] Use of Terraform modules and overall refactoring
- [ ] Rewrite and refactor the Lambda functions
- [ ] Error handling in the Lambda functions
- [ ] Variabilisation of the layers used in the Lambda functions because of region-lock

### v2

- [ ] Multiply the data sources on the text side (other subreddits...)

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
