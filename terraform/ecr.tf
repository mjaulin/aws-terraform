resource "aws_ecr_repository" "aws_terraform-ecr" {
  name = "aws_terraform-ecr"
}

resource "aws_ecr_lifecycle_policy" "aws_terraform-ecr_lifecycle_policy" {
  repository = "${aws_ecr_repository.aws_terraform-ecr.name}"

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