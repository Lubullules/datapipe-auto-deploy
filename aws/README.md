
terraform init -reconfigure -backend-config="region=eu-west-1"  -backend-config="bucket=aws-s3-base-bucket-project-test" -backend-config="key=terraform_state_folder/terraform_state"

terraform plan
terraform apply

Terraform names syntax: snake_case

AWS names syntax: CamelCase

Pour les variables : prio 1 tfvars, prio 2 variable d'env, prio 3 default

Pour delete les choses contenu dans un bucket S3 avant de le destroy : aws s3 rm s3://test-eu-west-1-v1 --recursive