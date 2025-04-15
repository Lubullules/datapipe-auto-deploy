# Setup env = dev
cd ~/Documents/Perso/finance-DE-lab/snowflake

export BUCKET_TF_STATE="aws-s3-base-bucket-project-test"
export KEY_TF_STATE="snowflake_dev/terraform.tfstate"

export TF_VAR_project_name="project-data-finance"
export TF_VAR_env="dev"

export TF_VAR_aws_key="aws_dev/terraform.tfstate"

PRIVATE_KEY=$(cat ../snowflake_private_key.p8)
export TF_VAR_snowflake_private_key="$PRIVATE_KEY"

terraform fmt --recursive

terraform init -backend-config="region=eu-west-1" -backend-config="bucket=$BUCKET_TF_STATE" -backend-config="key=$KEY_TF_STATE"

terraform apply