terraform {
  backend "s3" {
    bucket = "aws-s3-base-bucket-project-test"
    key    = "terraform_state_dev/backend.tfstate"
    region = "eu-west-1"
  }
}