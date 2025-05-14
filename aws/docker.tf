# Terraform configuration for building and pushing a Docker image to AWS ECR
resource "null_resource" "build_and_push_docker_image" {
  provisioner "local-exec" {
    command = <<EOT
      # Authenticate Docker to the ECR registry
      aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com

      # Build the Docker image
      docker build -t ${aws_ecr_repository.lambda.repository_url}:latest ./definitions/lambda-container

      # Push the Docker image to ECR
      docker push ${aws_ecr_repository.lambda.repository_url}:latest
    EOT
  }

  # TODO: Add a trigger to rebuild the image when the Dockerfile changes or when the source code changes instead of using a timestamp
  triggers = {
    build_number = "${timestamp()}"
  }
}