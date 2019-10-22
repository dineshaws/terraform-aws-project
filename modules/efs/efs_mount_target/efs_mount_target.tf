variable "file_system_id" {
  
}
variable "subnet_id" {
  
}


resource "aws_efs_mount_target" "efs_mount" {
  file_system_id = "${var.file_system_id}"
  subnet_id      = "${var.subnet_id}"
}