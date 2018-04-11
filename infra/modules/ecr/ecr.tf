resource "aws_ecr_repository" "ecr-front" {
  name = "aws-terraform-ecr-front"
}

resource "aws_ecr_lifecycle_policy" "ecr-lp-front" {
  repository = "${aws_ecr_repository.ecr-front.name}"

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

resource "aws_ecr_repository" "ecr-back" {
  name = "aws-terraform-ecr-back"
}

resource "aws_ecr_lifecycle_policy" "ecr-back-lp" {
  repository = "${aws_ecr_repository.ecr-back.name}"

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

output "ecr_repository_url_front" {
  value = "${aws_ecr_repository.ecr-front.repository_url}"
}


output "ecr_repository_url_back" {
  value = "${aws_ecr_repository.ecr-back.repository_url}"
}