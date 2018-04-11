variable "default_tags" { type = "map" }
variable "vpc_id" {}
variable "elb_securiy_id" {}
variable "subnets" { type = "list" }
variable "cluster_name" {}
variable "ami_id" {
  description = "AMI For ECS"
  default     = "ami-914afcec"
}
variable "instance_type" {
  default = "t2.micro"
}