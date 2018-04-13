resource "aws_iam_role" "ecs-dynamodb-host-role" {
  name = "ecs-dynamodb-host-role"
  assume_role_policy = "${file("${path.module}/policies/ecs-dynamodb-role.json")}"
}

resource "aws_iam_role_policy" "ecs-dynamodb-instance-role-policy" {
  name = "ecs-dynamodb-instance-role-policy"
  policy = "${file("${path.module}/policies/ecs-dynamodb-instance-role-policy.json")}"
  role = "${aws_iam_role.ecs-dynamodb-host-role.id}"
}

resource "aws_iam_instance_profile" "ecs-iam-ip" {
  name = "iam-instance-profile"
  role = "${aws_iam_role.ecs-dynamodb-host-role.name}"
}

resource "aws_security_group" "sg-ecs" {
  name   = "ecs-sg"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = 32768
    protocol        = "tcp"
    to_port         = 65535
    security_groups = ["${var.elb_securiy_id}"]
  }

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.default_tags, map("Name", "ecs-sg"))}"
}

resource "aws_launch_configuration" "lc" {
  instance_type               = "${var.instance_type}"
  image_id                    = "${var.ami_id}"
  security_groups             = ["${aws_security_group.sg-ecs.id}"]
  user_data                   = "${data.template_file.user_data.rendered}"
  iam_instance_profile        = "${aws_iam_instance_profile.ecs-iam-ip.name}"
  associate_public_ip_address = true
  key_name                    = "${aws_key_pair.aws-terraform.key_name}"

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "ag" {
  launch_configuration = "${aws_launch_configuration.lc.id}"
  max_size             = 1
  min_size             = 0
  desired_capacity     = 1
  force_delete         = true
  vpc_zone_identifier  = ["${var.subnets}"]
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user_data.sh")}"

  vars {
    ecs_cluster_name = "${var.cluster_name}"
  }
}