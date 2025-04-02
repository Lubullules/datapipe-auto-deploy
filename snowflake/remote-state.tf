module "aws" {
  source = "../aws"
}

data "terraform_remote_state" "aws" {
  backend = "s3"

  config = {
    s3_bucket_name = module.aws.s3_bucket_name
    snowpipe_role_arn = module.aws.snowpipe_role_arn
  }
}