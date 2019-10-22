module "shared_vars" {
  source = "../../shared_vars"
}

variable "lc_name" {
  
}
variable "tg_identifier" {
  
}
variable "subnets" {
  
}

variable "tg_arn" {
  
}





resource "aws_autoscaling_group" "asg_tg" {
  name                      = "platform-${var.tg_identifier}-${module.shared_vars.env_suffix}"
  max_size                  = "${module.shared_vars.env_asg_buyer_config.max}"
  min_size                  = "${module.shared_vars.env_asg_buyer_config.min}"
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = "${module.shared_vars.env_asg_buyer_config.desired}"
  launch_configuration      = "${var.lc_name}"
  vpc_zone_identifier       = "${var.subnets}" # this is list of subnet ids
  target_group_arns         = ["${var.tg_arn}"] # list of arn's

  tag {
    key                 = "env"
    value               = "${module.shared_vars.env_suffix}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "API Server ${var.tg_identifier}"
    propagate_at_launch = true
  }
}

output "asg_name" {
  value = "${aws_autoscaling_group.asg_tg.name}"
}
