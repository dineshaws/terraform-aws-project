variable "vpc_id" { 

}
module "shared_var_module" {
  source = "../../shared_vars"
}

resource "aws_security_group" "platform_elb_sg" {
  name        = "${module.shared_var_module.env_suffix}-API-ELB"
  description = "Allow ALB traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "http port"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "https port"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    description     = "open for all"
  }
}

resource "aws_security_group" "platform_sg" {
  name        = "${module.shared_var_module.env_suffix}Respondent"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "app port"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["103.118.168.137/32"]
    description = "dinesh ip"
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    security_groups = ["${aws_security_group.platform_elb_sg.id}"]
    description = "platform elb sg"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    description     = "open for all"
  }
}

output "platform_sg_id" {
  value = "${aws_security_group.platform_sg.id}"
}

output "platform_elb_sg_id" {
  value = "${aws_security_group.platform_elb_sg.id}"
}

