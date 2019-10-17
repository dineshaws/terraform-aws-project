variable "vpc_id" {
  
}
variable "main_rt_id" {
  
}
variable "igw_id" {
  
}
variable "ngw_id" {
  
}

module "shared_vars" {
  source = "../../shared_vars"
  
}


resource "aws_route" "main_route_table_route" {
  route_table_id = "${var.main_rt_id}"
  gateway_id = "${var.igw_id}"
  destination_cidr_block = "0.0.0.0/0"
}


resource "aws_route_table" "rt-private" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${var.ngw_id}"
  }

  tags = {
    Name = "Private RT ${module.shared_vars.env_suffix}"
  }
}