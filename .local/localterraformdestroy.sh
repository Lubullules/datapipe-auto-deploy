#!/bin/bash
# This script destroys the local terraform infrastructure
# It is assumed that the project structure is as imported
#------------------------------------------------------------
echo "This script destroys the local terraform infrastructure \n"
echo "Loading local environment variables... \n"
. "./.env.local"

echo "   Environment is $ENV"
echo "   Project name is $PROJECT_NAME"
echo "   AWS region is $AWS_REGION"

echo "   AWS bucket for tfstates is $TF_STATES_BASE_BUCKET_NAME"
echo "   Key for AWS tfstate is $AWS_TF_STATE_KEY"
echo "   Key for Snowflake tfstate is $SNOWFLAKE_TF_STATE_KEY"

export TF_VAR_env="$ENV"
export TF_VAR_project_name="$PROJECT_NAME"

export TF_VAR_aws_region="$AWS_REGION"
export TF_VAR_base_bucket="$TF_STATES_BASE_BUCKET_NAME"

echo "\n\n"

#------------------------------------------------------------
# Snowflake

echo "Destroying Snowflake infrastructure \n"
cd "./snowflake"

echo "   Snowflake private key has been loaded from $PRIVATE_KEY_PATH"
echo "   Snowflake organization name is $SNOWFLAKE_ORG_NAME"
echo "   Snowflake account name is $SNOWFLAKE_ACCOUNT_NAME \n"

export TF_VAR_aws_tf_state_key="$AWS_TF_STATE_KEY"

export TF_VAR_snowflake_private_key="$SNOWFLAKE_PRIVATE_KEY"
export TF_VAR_snowflake_org_name="$SNOWFLAKE_ORG_NAME"
export TF_VAR_snowflake_account_name="$SNOWFLAKE_ACCOUNT_NAME"

terraform destroy

echo "\n\n"

#------------------------------------------------------------
# AWS
echo "Destroying AWS infrastructure \n"
cd "../aws"

echo "   AWS account ID is $AWS_ACCOUNT_ID"

echo "   Snowflake AWS user ARN is $SNOWFLAKE_AWS_USER_ARN"

echo "   Reddit username is $REDDIT_USERNAME"
echo "   Reddit password is $REDDIT_PASSWORD"
echo "   Reddit client ID is $REDDIT_CLIENT_ID"
echo "   Reddit client secret is $REDDIT_CLIENT_SECRET \n"

export TF_VAR_aws_account_id="$AWS_ACCOUNT_ID"

export TF_VAR_snowflake_aws_user_arn="$SNOWFLAKE_AWS_USER_ARN"

export TF_VAR_reddit_username="$REDDIT_USERNAME"
export TF_VAR_reddit_password="$REDDIT_PASSWORD"
export TF_VAR_reddit_client_id="$REDDIT_CLIENT_ID"
export TF_VAR_reddit_client_secret="$REDDIT_CLIENT_SECRET"

terraform destroy