terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.87"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
}

provider "snowflake" {
  role = "SYSADMIN"
}