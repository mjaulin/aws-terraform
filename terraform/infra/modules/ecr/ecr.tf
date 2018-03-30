resource "aws_ecr_repository" "ecr" {
  name = "aws-terraform-ecr"
}

resource "aws_ecr_lifecycle_policy" "ecr-lp" {
  repository = "${aws_ecr_repository.ecr.name}"

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 3 images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["v"],
                "countType": "imageCountMoreThan",
                "countNumber": 3
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

output "ecr_repository_url" {
  value = "${aws_ecr_repository.ecr.repository_url}"
}