provider "aws" {
    region = "us-east-1"
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
  source = "./modules/vpc/nat_gateway"
  public_subnet_id = "${module.subnet_module.subnet_public_a_id}"
}
module "route_table_module" {
  source = "./modules/vpc/route_table"
  igw_id = "${module.igw_module.igw_id}"
  ngw_id = "${module.ngw_module.ngw_id}"
  main_rt_id = "${module.vpc_module.main_rt_id}"
  vpc_id = "${module.vpc_module.vpc_id}"
  subnet_public_a_id = "${module.subnet_module.subnet_public_a_id}"
  subnet_public_b_id = "${module.subnet_module.subnet_public_b_id}"
}
module "platform_lb_module" {
  source = "./modules/load_balancer/load_balancer"
  elb_sg_id = "${module.security_group_module.elb_sg_id}"
  subnets = ["${module.subnet_module.subnet_public_a_id}", "${module.subnet_module.subnet_public_b_id}"]
}
module "buyer_tg_module" {
  source = "./modules/load_balancer/target_group"
  vpc_id = "${module.vpc_module.vpc_id}"
  tg_name = "${module.shared_vars.env_suffix}-BuyerService"
}
module "supplier_tg_module" {
  source = "./modules/load_balancer/target_group"
  vpc_id = "${module.vpc_module.vpc_id}"
  tg_name = "${module.shared_vars.env_suffix}-SupplierrService"
}

module "lb_listener_module" {
  source = "./modules/load_balancer/lb_listener"
  load_balancer_arn = "${module.platform_lb_module.aws_lb_arn}"
  target_group_arn = "${module.buyer_tg_module.tg_arn}" # default target group
}


module "buyer_listener_rule_module" {
  source = "./modules/load_balancer/lb_listener_rule"
  path_pattern = ["/buyers/*"]
  listener_arn = "${module.lb_listener_module.lb_listener_arn}"
  target_group_arn = "${module.buyer_tg_module.tg_arn}"
}
module "supplier_listener_rule_module" {
  source = "./modules/load_balancer/lb_listener_rule"
  path_pattern = ["/suppliers/*"]
  listener_arn = "${module.lb_listener_module.lb_listener_arn}"
  target_group_arn = "${module.supplier_tg_module.tg_arn}"
}



