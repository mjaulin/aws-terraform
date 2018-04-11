output "ecr_repository_url_front" {
  value = "${module.ecr.ecr_repository_url_front}"
}

output "ecr_repository_url_back" {
  value = "${module.ecr.ecr_repository_url_back}"
}

output "ecs_cluster_id" {
  value = "${module.ecs.ecs_cluster_id}"
}

output "elb_target_group_arn_front" {
  value = "${module.elb.elb_target_group_arn_front}"
}

output "elb_target_group_arn_back" {
  value = "${module.elb.elb_target_group_arn_back}"
}

output "elb_public_dns_name" {
  value = "${module.elb.elb_public_dns_name}"
}