provider "aws" {
  region = "${var.region}"
}

module "vpc" {
  source = "./modules/vpc"

  default_tags = "${local.default_tags}"
}