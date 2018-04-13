variable "default_tags" { type = "map" }

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidr_block}"

  tags = "${var.default_tags}"
}

resource "aws_default_network_acl" "default" {
  default_network_acl_id = "${aws_vpc.vpc.default_network_acl_id}"

  tags = "${var.default_tags}"
}

resource "aws_subnet" "subnet" {
  count             = "${length(var.availability_zones)}"
  cidr_block        = "${cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  vpc_id            = "${aws_vpc.vpc.id}"

  tags = "${merge(var.default_tags, map("Name", "public"))}"
}

resource "aws_network_acl" "acl-ec2" {
  vpc_id = "${aws_vpc.vpc.id}"
  subnet_ids = ["${aws_subnet.subnet.*.id}"]

  ingress {
    action = "allow"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    rule_no = 100
    cidr_block = "0.0.0.0/0"
  }

  ingress {
    action = "allow"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    rule_no = 110
    cidr_block = "0.0.0.0/0"
  }

  ingress {
    action = "allow"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    rule_no = 120
    cidr_block = "0.0.0.0/0"
  }

  ingress {
    action = "allow"
    from_port = 32768
    to_port = 65535
    protocol = "tcp"
    rule_no = 130
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action = "allow"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    rule_no = 100
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action = "allow"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    rule_no = 110
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action = "allow"
    from_port = 32768
    to_port = 65535
    protocol = "tcp"
    rule_no = 120
    cidr_block = "0.0.0.0/0"
  }

  tags = "${var.default_tags}"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = "${var.default_tags}"
}

resource "aws_route_table" "rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = "${merge(var.default_tags, map("Name", "public"))}"
}

resource "aws_route_table_association" "rt-ass" {
  count          = "${aws_subnet.subnet.count}"
  subnet_id      = "${element(aws_subnet.subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.rt.id}"
}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "subnets" {
  value = "${aws_subnet.subnet.*.id}"
}