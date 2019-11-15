module "shared_vars" {
  source = "../../shared_vars"
}
variable "name" {}
variable "shard_count" {}
variable "retention_period" {}


resource "aws_kinesis_stream" "main" {
  name             = "${var.name}"
  shard_count      = "${var.shard_count}"
  retention_period = "${var.retention_period}"
  tags = {
    Environment = "${module.shared_vars.env_suffix}"
  }
}

output "stream_id" {
  value = "${aws_kinesis_stream.main.id}"
}
