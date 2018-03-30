provider "aws" {
  region = "${var.region}"
}

module "vpc" {
  source = "./modules/vpc"

  default_tags = "${local.default_tags}"
}

module "ecr" {
  source = "./modules/ecr"
}

module "ecs" {
  source = "./modules/ecs"
}

module "elb" {
  source = "./modules/elb"

  vpc_id = "${module.vpc.vpc_id}"
  subnets = "${module.vpc.subnets}"

  default_tags = "${local.default_tags}"
}

module "ec2" {
  source = "./modules/ec2"

  vpc_id = "${module.vpc.vpc_id}"
  subnets = "${module.vpc.subnets}"
  elb_securiy_id = "${module.elb.elb_securiy_id}"
  cluster_name = "${module.ecs.ecs_cluster_id}"

  default_tags = "${local.default_tags}"
}