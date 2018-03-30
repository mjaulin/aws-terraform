resource "aws_ecs_cluster" "aws_terraform-cluster" {
  name = "aws-terraform-cluster"
}

output "ecs_cluster_id" {
  value = "${aws_ecs_cluster.aws_terraform-cluster.id}"
}