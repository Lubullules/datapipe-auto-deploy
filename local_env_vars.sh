#!/bin/bash
# Variables declaration for local deploy or destroy of Terraform infrastructure

export ENV="dev"
export PROJECT_NAME="project-data-finance"

export TF_STATES_BASE_BUCKET_NAME="aws-s3-base-bucket-project-test"
export AWS_TF_STATE_BASE_BUCKET_KEY="aws_dev/terraform.tfstate"
export SNOWFLAKE_TF_STATE_BASE_BUCKET_KEY="snowflake_dev/terraform.tfstate"
export AWS_REGION="eu-west-1"

export PRIVATE_KEY_PATH="$HOME/Documents/Perso/finance-DE-lab/snowflake_private_key.p8"
export SNOWFLAKE_PRIVATE_KEY="$(cat $PRIVATE_KEY_PATH)"

export AWS_INFRASTRUCTURE_PATH="$HOME/Documents/Perso/finance-DE-lab/aws"
export SNOWFLAKE_INFRASTRUCTURE_PATH="$HOME/Documents/Perso/finance-DE-lab/snowflake"
