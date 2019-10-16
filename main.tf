provider "aws" {
    region = "us-east-1"
    profile = "developer"
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