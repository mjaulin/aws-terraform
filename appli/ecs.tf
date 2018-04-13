variable "ecr_repository_url_front" {}
variable "ecr_repository_url_back" {}
variable "ecs_cluster_id" {}
variable "elb_target_group_arn_front" {}
variable "elb_target_group_arn_back" {}
variable "elb_public_dns_name" {}

data "template_file" "td-front" {
  template = "${file("task-definitions/front.json")}"

  vars {
    ecr_repository_url = "${var.ecr_repository_url_front}"
  }
}

data "template_file" "td-back" {
  template = "${file("task-definitions/back.json")}"

  vars {
    ecr_repository_url = "${var.ecr_repository_url_back}"
  }
}

resource "aws_ecs_task_definition" "ecs-task-front" {
  family                = "aws_terraform_front"
  container_definitions = "${data.template_file.td-front.rendered}"
}

resource "aws_ecs_task_definition" "ecs-task-back" {
  family                = "aws_terraform_back"
  container_definitions = "${data.template_file.td-back.rendered}"
}

resource "aws_ecs_service" "ecs-service-front" {
  name            = "aws_terraform-service-front"
  cluster         = "${var.ecs_cluster_id}"
  task_definition = "${aws_ecs_task_definition.ecs-task-front.arn}"
  desired_count   = 1

  load_balancer {
    target_group_arn = "${var.elb_target_group_arn_front}"
    container_name   = "front"
    container_port   = 80
  }
}

resource "aws_ecs_service" "ecs-service-back" {
  name            = "aws_terraform-service-back"
  cluster         = "${var.ecs_cluster_id}"
  task_definition = "${aws_ecs_task_definition.ecs-task-back.arn}"
  desired_count   = 1

  load_balancer {
    target_group_arn = "${var.elb_target_group_arn_back}"
    container_name   = "back"
    container_port   = 8080
  }
}

output "elb_public_dns_name" {
  value = "${var.elb_public_dns_name}"
}