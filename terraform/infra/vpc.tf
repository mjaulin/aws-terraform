locals {
  vpc_public_cidr_block = "${cidrsubnet(aws_vpc.aws_terraform-vpc.cidr_block, 1, 0)}"
}

resource "aws_vpc" "aws_terraform-vpc" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = "${local.default_tags}"
}

resource "aws_default_network_acl" "aws_terraform-defautl_acl" {
  default_network_acl_id = "${aws_vpc.aws_terraform-vpc.default_network_acl_id}"

  tags = "${local.default_tags}"
}

resource "aws_default_route_table" "aws_terraform-default_route_table" {
  default_route_table_id = "${aws_vpc.aws_terraform-vpc.default_route_table_id}"

  tags = "${local.default_tags}"
}

resource "aws_subnet" "aws_terraform-subnet" {
  count             = "${length(var.availability_zones)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  vpc_id            = "${aws_vpc.aws_terraform-vpc.id}"
  cidr_block        = "${cidrsubnet(local.vpc_public_cidr_block, 3, count.index)}"

  tags = "${merge(local.default_tags, map("Name", "public"))}"
}

resource "aws_internet_gateway" "aws_terraform-internet_gateway" {
  vpc_id = "${aws_vpc.aws_terraform-vpc.id}"

  tags = "${local.default_tags}"
}

resource "aws_route_table" "aws_terraform-route_table" {
  vpc_id = "${aws_vpc.aws_terraform-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.aws_terraform-internet_gateway.id}"
  }

  tags = "${merge(local.default_tags, map("Name", "public"))}"
}

resource "aws_route_table_association" "aws_terraform-route_table_association" {
  count          = "${aws_subnet.aws_terraform-subnet.count}"
  subnet_id      = "${element(aws_subnet.aws_terraform-subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.aws_terraform-route_table.id}"
}

resource "aws_network_acl" "aws_terraform-aws_network_acl" {
  vpc_id     = "${aws_vpc.aws_terraform-vpc.id}"
  subnet_ids = ["${aws_subnet.aws_terraform-subnet.*.id}"]

  tags = "${merge(local.default_tags, map("Name", "public"))}"
}

resource "aws_network_acl_rule" "aws_terraform-ingress_http_server" {
  network_acl_id = "${aws_network_acl.aws_terraform-aws_network_acl.id}"
  egress         = false
  rule_number    = 1
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "aws_terraform-egress_http_server" {
  network_acl_id = "${aws_network_acl.aws_terraform-aws_network_acl.id}"
  egress         = true
  rule_number    = 1
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}