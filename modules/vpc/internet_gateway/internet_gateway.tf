variable "vpc_id" {}

module "shared_vars" {
  source = "../../shared_vars"
}
resource "aws_internet_gateway" "igw" {
  vpc_id = "${var.vpc_id}"

  tags = {
    Name = "IGW-${module.shared_vars.env_suffix}"
  }
}

output "igw_id" {
  value = "${aws_internet_gateway.igw.id}"
}
