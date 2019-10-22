variable "asg_name" {
  
}

variable "target_name" {
  
}

module "shared_vars" {
  source = "../../shared_vars"
}



resource "aws_autoscaling_policy" "asg_policy" {
  name                      = "asg-policy-${var.target_name}-${module.shared_vars.env_suffix}"
  adjustment_type           = "ChangeInCapacity"
  autoscaling_group_name    = "${var.asg_name}"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 200

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = "60"
  }
}