# Terraform configuration for building and pushing a Docker image to AWS ECR
resource "aws_ecr_repository" "lambda" {
  name = "${local.project_acronym_lower}-${var.env}-lambda-container-image"

  force_delete = true
}