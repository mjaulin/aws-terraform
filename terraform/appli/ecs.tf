variable "ecr_repository_url" {}
variable "ecs_cluster_id" {}
variable "elb_target_group_arn" {}

data "template_file" "td" {
  template = "${file("task-definitions/nginx.json")}"

  vars {
    ecr_repository_url = "${var.ecr_repository_url}"
  }
}

resource "aws_ecs_task_definition" "ecs-task" {
  family                = "aws_terraform"
  container_definitions = "${data.template_file.td.rendered}"
}

resource "aws_ecs_service" "ecs-service" {
  name            = "aws_terraform-service"
  cluster         = "${var.ecs_cluster_id}"
  task_definition = "${aws_ecs_task_definition.ecs-task.arn}"
  desired_count   = 0

  load_balancer {
    target_group_arn = "${var.elb_target_group_arn}"
    container_name   = "nginx"
    container_port   = 80
  }
}