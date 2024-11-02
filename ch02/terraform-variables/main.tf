terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }
}
resource "local_file" "hello" {
  filename = var.filename
  content = var.content
  file_permission = "0700"
}

resource "random_string" "random_code" {
  length = 5
  special = false
  upper = false
}

# resource "aws_instance" "ec2" {
#   ami = var.server.ami
#   instance_type = var.server.instance_type
# }

# cli argument
# terraform plan -var="filename='/tmp/world.txt'" -var="content='hi hi hi'"

# environment variable
# export TF_VAR_filename=/tmp/world1.txt && terraform plan