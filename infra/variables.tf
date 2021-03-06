variable "region" {
  description = "AWS region"
  default     = "eu-west-3"  # Paris
}

variable "availability_zones" {
  description = "AWS availability zones"
  type = "list"
  default = [
    "eu-west-3a",
    "eu-west-3b",
  ]
}

variable "cidr_block" {
  description = "CIDR block of the VPC"
  default     = "10.0.0.0/16"
}

locals {
  default_tags = {
    Name        = "aws_terraform"
    Provisioner = "terraform"
  }
}