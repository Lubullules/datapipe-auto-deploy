resource "aws_ecr_repository" "lambda_repo" {
  name = "${var.project_name}-${var.env}-lambda-container-image"

  force_delete = true
}