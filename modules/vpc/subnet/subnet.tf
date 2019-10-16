variable "vpc_id" {}

module "shared_vars" {
	source = "../../shared_vars"
}

locals {
  env = "${terraform.workspace}"
  env_subnet_public_a_cidr = {
    default = "10.0.0.0/24"
    staging = "10.0.0.0/24"
    production = "172.31.16.0/20"
  }
  subnet_public_a_cidr = "${lookup(local.env_subnet_public_a_cidr, local.env)}"

  env_subnet_public_b_cidr = {
    default = "10.0.8.0/24"
    staging = "10.0.8.0/24"
    production = "172.31.64.0/20"
  }
  subnet_public_b_cidr = "${lookup(local.env_subnet_public_b_cidr, local.env)}"
}


resource "aws_subnet" "subnet_public_a" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "${local.subnet_public_a_cidr}"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "${module.shared_vars.env_suffix}-public-a"
  }
}

resource "aws_subnet" "subnet_public_b" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "${local.subnet_public_b_cidr}"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "${module.shared_vars.env_suffix}-public-b"
  }
}

output "subnet_public_a_id" {
	value = "${aws_subnet.subnet_public_a.id}"
}

output "subnet_public_b_id" {
  value = "${aws_subnet.subnet_public_b.id}"
}
