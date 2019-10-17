variable "public_subnet_id" {}
module "shared_vars" {
  source = "../../shared_vars"
}

resource "aws_eip" "ngw_eip" {
  vpc = true
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = "${aws_eip.ngw_eip.id}"
  subnet_id     = "${var.public_subnet_id}"
  tags = {
    Name = "gw NAT ${module.shared_vars.env_suffix}"
  }
}

output "ngw_id" {
  value = "${aws_nat_gateway.ngw.id}"
}
