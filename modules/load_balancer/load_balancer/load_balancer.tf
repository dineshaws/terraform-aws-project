variable "elb_sg_id" {
  
}
variable "subnets" {
  
}
module "shared_vars" {
  source = "../../shared_vars"
}


resource "aws_lb" "platform_lb" {
  name               = "platform-lb-${module.shared_vars.env_suffix}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${var.elb_sg_id}"]
  subnets            = "${var.subnets}" // this is set of subnets
  enable_deletion_protection = false
  tags = {
    Environment = "${module.shared_vars.env_suffix}"
  }
}

output "aws_lb_arn" {
  value = "${aws_lb.platform_lb.arn}"
}
