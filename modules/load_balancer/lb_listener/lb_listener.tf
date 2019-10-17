variable "load_balancer_arn" {
  
}
variable "target_group_arn" {
  
}


resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = "${var.load_balancer_arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${var.target_group_arn}"
  }
}

output "lb_listener_arn" {
  value = "${aws_lb_listener.http_listener.arn}"
}
