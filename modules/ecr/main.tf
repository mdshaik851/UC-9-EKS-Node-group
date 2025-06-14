resource "aws_ecr_repository" "repo_eks" {
  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  repository = aws_ecr_repository.repo_eks.name
  policy     = <<EOF
  {
    "rules": [
      {
        "rulePriority": 1,
        "description": "Keep last 30 images",
        "selection": {
          "tagStatus": "any",
          "countType": "imageCountMoreThan",
          "countNumber": 30
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }
  EOF
}