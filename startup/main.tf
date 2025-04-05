locals {
  user_data = <<-EOT
#!/bin/bash
yum update -y
yum install -y nginx
systemctl enable nginx
systemctl start nginx
cd /usr/share/nginx/html
echo "<center><h1>Hello Lucky Vanilla 3</h1><h2>This is Lucky Vanilla 3's shopping mall. </h2><h3>Working very well. Good luck</h3></center>" > index.html
EOT
}

data "aws_vpc" "default" {
  default = true
}


# EC2
module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.8.0"

  name = "LuckyInstance"

  instance_type          = "t2.micro"
  user_data = local.user_data
}

# SG
module "lucky-webapp-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name        = "LuckyWEBAPP-SG"
  description = "Allow SSH, HTTP, HTTPS"
  ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp",
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "http-80-tcp",
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "https-443-tcp",
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

module "lucky-alb-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name        = "LuckyALB-SG"
  description = "Allow HTTP, HTTPS"
  ingress_with_cidr_blocks = [
    {
      rule        = "http-80-tcp",
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "https-443-tcp",
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

# ALB
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.15.0"
  name = "LuckyALB"

  vpc_id = data.aws_vpc.default.id
  subnets = ["default"]
  security_groups = [
    module.lucky-alb-sg.security_group_id
  ]

  listeners = {
    lucky-alb = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "lucky-instnace"
      }
    }
  }

  target_groups = {
    lucky-instnace = {
      target_type = "instance"
      target_id = module.ec2-instance.id
    }
  }

}