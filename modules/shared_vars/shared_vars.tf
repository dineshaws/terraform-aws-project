locals {
    env = "${terraform.workspace}"
    env_suffix_map = {
        default = "staging"
        staging = "staging"
        production = "production"
    }
    env_suffix = "${lookup(local.env_suffix_map, local.env)}"
}

output "env_suffix" {
    value = "${local.env_suffix}"
}