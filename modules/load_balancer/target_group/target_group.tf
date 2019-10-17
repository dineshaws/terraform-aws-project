variable "tg_name" {
  
}
variable "vpc_id" {
  
}
module "shared_vars" {
  source = "../../shared_vars"
}

resource "aws_lb_target_group" "tg" {
  name     = "${var.tg_name}"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
  tags = {
      env = "${module.shared_vars.env_suffix}"
  }
}

output "tg_arn" {
  value = "${aws_lb_target_group.tg.arn}"
}
