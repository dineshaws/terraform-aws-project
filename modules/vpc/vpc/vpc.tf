module "shared_vars" {
	source = "../../shared_vars"
}

locals {
  env = "${terraform.workspace}"
  env_vpc_cidr = {
    default = "10.0.0.0/16"
    staging = "10.0.0.0/16"
    production = "172.31.16.0/20"
  }
  vpc_cidr = "${lookup(local.env_vpc_cidr, local.env)}"
}

resource "aws_vpc" "main" {
  cidr_block       = "${local.vpc_cidr}"
  tags = {
    Name = "${module.shared_vars.env_suffix}"
  }
}

output "vpc_id" {
	value = "${aws_vpc.main.id}"
}