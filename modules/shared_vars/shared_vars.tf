locals {
    env = "${terraform.workspace}"
    env_suffix_map = {
        default = "staging"
        staging = "staging"
        production = "production"
    }
    env_suffix = "${lookup(local.env_suffix_map, local.env)}"
    env_platform_ami_map = {
        default = "ami-00eb20669e0990cb4"
        staging = "ami-00eb20669e0990cb4"
        production = "ami-0b69ea66ff7391e80"
    }
    env_platform_ami = "${lookup(local.env_platform_ami_map, local.env)}"

     env_platform_keypair_map = {
        default = "terraform-test"
        staging = "terraform-test"
        production = "terraform-test"
    }
    env_platform_keypair = "${lookup(local.env_platform_keypair_map, local.env)}"

    env_platform_instance_type_map = {
        default = "t2.micro"
        staging = "t2.micro"
        production = "t2.micro"
    }
    env_platform_instance_type = "${lookup(local.env_platform_instance_type_map, local.env)}"

    env_asg_buyer_config_map = {
        default = {
            min = 1
            max = 1
            desired = 1
        }
        staging = {
            min = 1
            max = 1
            desired = 1
        }
        production = {
            min = 2
            max = 1
            desired = 2
        }
    }
    env_asg_buyer_config = "${lookup(local.env_asg_buyer_config_map, local.env)}"

}

output "env_suffix" {
    value = "${local.env_suffix}"
}

output "env_platform_ami" {
    value = "${local.env_platform_ami}"
}

output "env_platform_keypair" {
    value = "${local.env_platform_keypair}"
}

output "env_platform_instance_type" {
    value = "${local.env_platform_instance_type}"
}

output "env_asg_buyer_config" {
  value = "${local.env_asg_buyer_config}"
}
