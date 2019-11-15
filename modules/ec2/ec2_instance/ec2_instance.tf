variable "name" {}
variable "ami_id" {}
variable "instance_type" {}
variable "iam_instance_profile" {}
variable "key_name" {}
variable "security_groups" {}
variable "subnet_id" {}




resource "aws_instance" "standalone" {
  ami                    = "${var.ami_id}"
  instance_type          = "${var.instance_type}"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = "${var.security_groups}" # this is list
  subnet_id              = "${var.subnet_id}"
  iam_instance_profile   = "${var.iam_instance_profile}"
  tags = {
    Name = "${var.name}"
  }
}

output "instance_id" {
  value = "${aws_instance.standalone.id}"
}

