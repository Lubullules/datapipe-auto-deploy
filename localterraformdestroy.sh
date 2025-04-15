cd ~/Documents/Perso/finance-DE-lab/aws

terraform destroy

cd ~/Documents/Perso/finance-DE-lab/snowflake

export TF_VAR_aws_key="aws_dev/terraform.tfstate"

PRIVATE_KEY=$(cat ../snowflake_private_key.p8)
export TF_VAR_snowflake_private_key="$PRIVATE_KEY"

terraform destroy