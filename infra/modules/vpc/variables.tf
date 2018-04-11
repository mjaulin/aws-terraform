variable "availability_zones" {
  description = "AWS availability zones"

  default = [
    "eu-west-3a",
    "eu-west-3b",
  ]
}

variable "cidr_block" {
  description = "CIDR block of the VPC"
  default     = "10.0.0.0/16"
}