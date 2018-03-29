resource "aws_ecs_cluster" "aws_terraform-cluster" {
  name = "aws_terraform-cluster"
}

resource "aws_ecs_task_definition" "aws_terraform-ecs_task" {
  family                = "aws_terraform"
  container_definitions = "${file("task-definitions/nginx.json")}"
}

resource "aws_ecs_service" "aws_terraform-ecs_service" {
  name            = "aws_terraform-service"
  cluster         = "${aws_ecs_cluster.aws_terraform-cluster.id}"
  task_definition = "${aws_ecs_task_definition.aws_terraform-ecs_task.arn}"
  desired_count   = 0

  load_balancer {
    elb_name       = "${aws_lb.aws_terraform-lb.name}"
    container_name = "nginx"
    container_port = 80
  }
}