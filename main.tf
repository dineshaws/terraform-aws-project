provider "aws" {
  region  = "us-east-1"
  profile = "developer"
}
module "shared_vars" {
  source = "./modules/shared_vars"
}
module "vpc_module" {
  source = "./modules/vpc/vpc"
}
module "subnet_module" {
  source = "./modules/vpc/subnet"
  vpc_id = "${module.vpc_module.vpc_id}"
}
module "security_group_module" {
  source = "./modules/vpc/security_group"
  vpc_id = "${module.vpc_module.vpc_id}"
}
module "igw_module" {
  source = "./modules/vpc/internet_gateway"
  vpc_id = "${module.vpc_module.vpc_id}"
}
module "ngw_module" {
  source           = "./modules/vpc/nat_gateway"
  public_subnet_id = "${module.subnet_module.subnet_public_a_id}"
}
module "route_table_module" {
  source             = "./modules/vpc/route_table"
  igw_id             = "${module.igw_module.igw_id}"
  ngw_id             = "${module.ngw_module.ngw_id}"
  main_rt_id         = "${module.vpc_module.main_rt_id}"
  vpc_id             = "${module.vpc_module.vpc_id}"
  subnet_public_a_id = "${module.subnet_module.subnet_public_a_id}"
  subnet_public_b_id = "${module.subnet_module.subnet_public_b_id}"
}
module "platform_lb_module" {
  source    = "./modules/load_balancer/load_balancer"
  elb_sg_id = "${module.security_group_module.elb_sg_id}"
  subnets   = ["${module.subnet_module.subnet_public_a_id}", "${module.subnet_module.subnet_public_b_id}"]
}
module "buyer_tg_module" {
  source  = "./modules/load_balancer/target_group"
  vpc_id  = "${module.vpc_module.vpc_id}"
  tg_name = "${module.shared_vars.env_suffix}-BuyerService"
}
module "supplier_tg_module" {
  source  = "./modules/load_balancer/target_group"
  vpc_id  = "${module.vpc_module.vpc_id}"
  tg_name = "${module.shared_vars.env_suffix}-SupplierrService"
}

module "lb_listener_module" {
  source            = "./modules/load_balancer/lb_listener"
  load_balancer_arn = "${module.platform_lb_module.aws_lb_arn}"
  target_group_arn  = "${module.buyer_tg_module.tg_arn}" # default target group
}


module "buyer_listener_rule_module" {
  source           = "./modules/load_balancer/lb_listener_rule"
  path_pattern     = ["/buyers/*"]
  listener_arn     = "${module.lb_listener_module.lb_listener_arn}"
  target_group_arn = "${module.buyer_tg_module.tg_arn}"
}
module "supplier_listener_rule_module" {
  source           = "./modules/load_balancer/lb_listener_rule"
  path_pattern     = ["/suppliers/*"]
  listener_arn     = "${module.lb_listener_module.lb_listener_arn}"
  target_group_arn = "${module.supplier_tg_module.tg_arn}"
}

module "platform_launch_config" {
  source               = "./modules/ec2/launch_configuration"
  name                 = "platform-launch-configuration-${module.shared_vars.env_suffix}"
  image_id             = "${module.shared_vars.env_platform_ami}"
  instance_type        = "${module.shared_vars.env_platform_instance_type}"
  iam_instance_profile = ""
  key_name             = "${module.shared_vars.env_platform_keypair}"
  security_groups      = ["${module.security_group_module.platform_sg_id}"]
}

module "asg_buyer" {
  source        = "./modules/ec2/asg"
  subnets       = ["${module.subnet_module.subnet_public_a_id}", "${module.subnet_module.subnet_public_b_id}"]
  tg_identifier = "Buyer"
  lc_name       = "${module.platform_launch_config.lc_name}"
  tg_arn        = "${module.buyer_tg_module.tg_arn}"
}

module "asg_supplier" {
  source        = "./modules/ec2/asg"
  subnets       = ["${module.subnet_module.subnet_public_a_id}", "${module.subnet_module.subnet_public_b_id}"]
  tg_identifier = "Supplier"
  lc_name       = "${module.platform_launch_config.lc_name}"
  tg_arn        = "${module.supplier_tg_module.tg_arn}"
}


# attaching auto scaling group policy to buyer asg
module "asg_buyer_policy" {
  source      = "./modules/ec2/asg_policy"
  asg_name    = "${module.asg_buyer.asg_name}"
  target_name = "Buyer"
}

# attaching auto scaling group policy to supplier asg
module "asg_supplier_policy" {
  source      = "./modules/ec2/asg_policy"
  asg_name    = "${module.asg_supplier.asg_name}"
  target_name = "Supplier"
}


# Create EFS file system
module "platform_efs" {
  source       = "./modules/efs/efs_file_system"
  unique_token = "platform-efs"
}
# EFS Mount Target on public subnet a
module "platform_efs_mount_a" {
  source         = "./modules/efs/efs_mount_target"
  file_system_id = "${module.platform_efs.file_system_id}"
  subnet_id      = "${module.subnet_module.subnet_public_a_id}"
}
# EFS Mount Target on public subnet b
module "platform_efs_mount_b" {
  source         = "./modules/efs/efs_mount_target"
  file_system_id = "${module.platform_efs.file_system_id}"
  subnet_id      = "${module.subnet_module.subnet_public_b_id}"
}

# sqs queue for Platform
module "sqs_queue_ht" {
  source            = "./modules/sqs/sqs_queue"
  queue_name        = "platform-ht"
  delay_seconds     = "90"
  message_size      = "2048"
  retention_seconds = "86400"
  wait_time         = "10"
}

# Launch EC2 instance 
module "platform_ec2_instance" {
  source               = "./modules/ec2/ec2_instance"
  name                 = "FOO-${module.shared_vars.env_suffix}"
  ami_id               = "${module.shared_vars.env_platform_ami}"
  instance_type        = "${module.shared_vars.env_platform_instance_type}"
  iam_instance_profile = ""
  key_name             = "${module.shared_vars.env_platform_keypair}"
  security_groups      = ["${module.security_group_module.platform_sg_id}"]
  subnet_id            = "${module.subnet_module.subnet_public_a_id}"
}

# Create Kinesis Stream
module "platform_kinesis_stream" {
  source           = "./modules/kinesis/kinesis_stream"
  name             = "Foo-${module.shared_vars.env_suffix}"
  shard_count      = "1"
  retention_period = "48"
}
