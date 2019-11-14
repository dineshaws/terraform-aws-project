variable "queue_name" {}
variable "delay_seconds" {}
variable "message_size" {}
variable "retention_seconds" {}
variable "wait_time" {}
module "shared_vars" {
  source = "../../shared_vars"
}

resource "aws_sqs_queue" "terraform_queue" {
  name                      = "${var.queue_name}-${module.shared_vars.env_suffix}"
  delay_seconds             = "${var.delay_seconds}"
  max_message_size          = "${var.message_size}"
  message_retention_seconds = "${var.retention_seconds}"
  receive_wait_time_seconds = "${var.wait_time}"
  tags = {
    Environment = "${module.shared_vars.env_suffix}"
  }
}

output "sqs_queue_id" {
  value = "${aws_sqs_queue.terraform_queue.id}"
}
