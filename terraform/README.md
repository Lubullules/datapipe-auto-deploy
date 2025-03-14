
terraform init -reconfigure -backend-config="region=eu-west-1"  -backend-config="bucket=aws-base-albert-project-ve-eu-west-1" -backend-config="key=terraform_state_folder/terraform_state"

terraform plan
terraform apply 
  