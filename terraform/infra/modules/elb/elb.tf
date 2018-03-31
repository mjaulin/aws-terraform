variable "default_tags" { type = "map" }
variable "vpc_id" {}
variable "subnets" { type = "list" }

resource "aws_security_group" "sg-elb" {
  name   = "elb-sg"
  vpc_id = "${var.vpc_id}"

  ingress {
    description = "HTTP"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.default_tags, map("Name", "elb-sg"))}"
}

resource "aws_lb" "lb" {
  name     = "aws-terraform-elb"
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.sg-elb.id}"]
  subnets            = ["${var.subnets}"]

  tags = "${var.default_tags}"
}

resource "aws_lb_target_group" "lb-tg" {
  name     = "aws-terraform-elb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  health_check {
    protocol            = "HTTP"
    port                = "traffic-port"
    path                = "/health"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "204"
  }

  tags = "${var.default_tags}"
}

resource "aws_lb_listener" "aws_terraform-lb_listener" {
  load_balancer_arn = "${aws_lb.lb.arn}"
  protocol          = "HTTP"
  port              = 80

  default_action {
    target_group_arn = "${aws_lb_target_group.lb-tg.arn}"
    type             = "forward"
  }
}

output "elb_target_group_arn" {
  value = "${aws_lb_target_group.lb-tg.arn}"
}

output "elb_securiy_id" {
  value = "${aws_security_group.sg-elb.id}"
}