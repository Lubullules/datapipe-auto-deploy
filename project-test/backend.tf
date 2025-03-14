terraform {
  backend "s3" {
    bucket = "aws-s3-base-bucket-project-test"
    key    = "project-test/backend.tfstate"
    region = "eu-west-1"
  }
}