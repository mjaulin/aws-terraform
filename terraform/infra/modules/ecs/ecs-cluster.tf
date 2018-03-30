resource "aws_ecs_cluster" "cluster" {
  name = "aws-terraform-cluster"
}

output "ecs_cluster_id" {
  value = "${aws_ecs_cluster.cluster.name}"
}