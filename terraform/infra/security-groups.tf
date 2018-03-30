resource "aws_security_group" "aws_terraform-security_group_elb" {
  name   = "aws_terraform-elb-secu-group"
  vpc_id = "${aws_vpc.aws_terraform-vpc.id}"

  ingress {
    description = "HTTP"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${local.default_tags}"
}

resource "aws_security_group" "aws_terraform-security_group_ecs" {
  name   = "aws_terraform-ecs-secu-group"
  vpc_id = "${aws_vpc.aws_terraform-vpc.id}"

  ingress {
    protocol = "tcp"
    from_port = 0
    to_port = 65535
    security_groups = ["${aws_security_group.aws_terraform-security_group_elb.id}"]
  }

  tags = "${local.default_tags}"
}