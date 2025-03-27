data "terraform_remote_state" "aws" {
  backend = "s3"

  config = {
    bucket = var.bucket
    region = var.region
    key    = var.key
  }
}
