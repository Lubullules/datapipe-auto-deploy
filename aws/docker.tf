resource "null_resource" "build_and_push_docker_image" {
  provisioner "local-exec" {
    command = <<EOT
      # Authenticate Docker to the ECR registry
      aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${var.account_id}.dkr.ecr.${var.region}.amazonaws.com

      # Build the Docker image
      docker build -t ${aws_ecr_repository.lambda_repo.repository_url}:latest ./definitions/lambda

      # Push the Docker image to ECR
      docker push ${aws_ecr_repository.lambda_repo.repository_url}:latest
    EOT
  }

  triggers = {
    build_number = "${timestamp()}"
  }
}