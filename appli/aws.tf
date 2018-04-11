variable "region" {
  default = "eu-west-3"
}

provider "aws" {
  region = "${var.region}"
}