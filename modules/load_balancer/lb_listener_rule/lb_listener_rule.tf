variable "listener_arn" {
  
}
variable "target_group_arn" {
  
}

variable "path_pattern" {
  
}

resource "aws_lb_listener_rule" "forward_rule" {
  listener_arn = "${var.listener_arn}"
  action {
    type             = "forward"
    target_group_arn = "${var.target_group_arn}"
  }
  condition {
    field  = "path-pattern"
    values = "${var.path_pattern}"
  }
}