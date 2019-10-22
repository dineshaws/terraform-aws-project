variable "unique_token" {
  
}
module "shared_vars" {
  source = "../../shared_vars"
  
}


resource "aws_efs_file_system" "efs_with_lifecyle_policy" {
  creation_token = "${module.shared_vars.env_suffix}-${var.unique_token}"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  tags = {
    Name = "${module.shared_vars.env_suffix}-EFS"
  }
}

output "file_system_id" {
  value = "${aws_efs_file_system.efs_with_lifecyle_policy.id}"
}
