output "ecr_repository_url" {
  value = "${module.ecr.ecr_repository_url}"
}

output "ecs_cluster_id" {
  value = "${module.ecs.ecs_cluster_id}"
}

output "elb_target_group_arn" {
  value = "${module.elb.elb_target_group_arn}"
}