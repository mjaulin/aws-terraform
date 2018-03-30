resource "aws_launch_configuration" "aws_terraform-lauch_configuration" {
  instance_type   = "t2.micro"
  image_id        = "${var.ami_id}"
  security_groups = ["${aws_security_group.aws_terraform-security_group_ecs.id}"]
  user_data = "${data.template_file.user_data.rendered}"
  iam_instance_profile = "${aws_iam_instance_profile.aws_terraform-iam_instance_profile.name}"

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "aws_terraform-autoscaling_group" {
  launch_configuration = "${aws_launch_configuration.aws_terraform-lauch_configuration.id}"
  max_size             = 1
  min_size             = 1
  desired_capacity     = 1
  force_delete         = true
  vpc_zone_identifier  = ["${aws_subnet.aws_terraform-subnet.*.id}"]
}

resource "aws_iam_instance_profile" "aws_terraform-iam_instance_profile" {
  name = "iam-instance-profile"
  role = "ecsInstanceRole"
}

data "template_file" "user_data" {
  template = "${file("user_data.sh")}"

  vars {
    ecs_cluster_name = "${aws_ecs_cluster.aws_terraform-cluster.name}"
  }
}