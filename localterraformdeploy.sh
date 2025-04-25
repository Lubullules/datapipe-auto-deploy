#!/bin/bash
echo "Loading local environment variables..."
. $HOME/Documents/Perso/finance-DE-lab/local_env_vars.sh

echo "Environment is $ENV"
echo "Project name is $PROJECT_NAME"
echo "AWS region is $AWS_REGION"
echo "AWS bucket for tfstates is $TF_STATES_BASE_BUCKET_NAME"
echo "Key for AWS tfstate is $AWS_TF_STATE_BASE_BUCKET_KEY"
echo "Key for Snowflake tfstate is $SNOWFLAKE_TF_STATE_BASE_BUCKET_KEY"
echo "Snowflake private key has been loaded from $PRIVATE_KEY_PATH"

export TF_VAR_project_name=$PROJECT_NAME
export TF_VAR_env=$ENV

echo -e "\n\n\n"

#------------------------------------------------------------

# AWS
echo "Deploying AWS infrastructure from $AWS_INFRASTRUCTURE_PATH"
cd $AWS_INFRASTRUCTURE_PATH

terraform fmt --recursive
terraform init  -backend-config="region=$AWS_REGION" -backend-config="bucket=$TF_STATES_BASE_BUCKET_NAME" -backend-config="key=$AWS_TF_STATE_BASE_BUCKET_KEY"
terraform apply

echo -e "\n\n\n"

#------------------------------------------------------------
# Snowflake

echo "Deploying Snowflake infrastructure from $SNOWFLAKE_INFRASTRUCTURE_PATH"
cd $SNOWFLAKE_INFRASTRUCTURE_PATH

export TF_VAR_aws_key="$AWS_TF_STATE_BASE_BUCKET_KEY"
export TF_VAR_snowflake_private_key="$SNOWFLAKE_PRIVATE_KEY"

terraform fmt --recursive
terraform init -backend-config="region=$AWS_REGION" -backend-config="bucket=$TF_STATES_BASE_BUCKET_NAME" -backend-config="key=$SNOWFLAKE_TF_STATE_BASE_BUCKET_KEY"
terraform apply