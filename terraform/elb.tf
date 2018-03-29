resource "aws_lb" "aws_terraform-lb" {
  name     = "aws-terraform-elb"
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.aws_terraform-security_group_elb.id}"]
  subnets            = ["${aws_subnet.aws_terraform-subnet.*.id}"]

  tags = "${local.default_tags}"
}

resource "aws_lb_target_group" "aws_terraform-lb_target_group" {
  name     = "aws-terraform-elb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.aws_terraform-vpc.id}"

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

  tags = "${local.default_tags}"
}

resource "aws_lb_listener" "aws_terraform-lb_listener" {
  load_balancer_arn = "${aws_lb.aws_terraform-lb.arn}"
  protocol          = "HTTP"
  port              = 80

  default_action {
    target_group_arn = "${aws_lb_target_group.aws_terraform-lb_target_group.arn}"
    type             = "forward"
  }
}