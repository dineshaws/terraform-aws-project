variable "image_id" {
  
}
variable "instance_type" {
  
}
variable "iam_instance_profile" {
  
}
variable "key_name" {
  
}
variable "security_groups" {
  
}
variable "name" {
  
}

resource "aws_launch_configuration" "as_conf" {
  name = "${var.name}"
  image_id      = "${var.image_id}"
  instance_type = "${var.instance_type}"
  iam_instance_profile = "${var.iam_instance_profile}"
  key_name = "${var.key_name}"
  security_groups = "${var.security_groups}" # this is array
}

output "launch_config_id" {
  value = "${aws_launch_configuration.as_conf.id}"
}
output "lc_name" {
  value = "${aws_launch_configuration.as_conf.name}"
}

