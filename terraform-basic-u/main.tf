provider "aws" {
  profile = "kopher-terraform" // aws profile
  region = "ap-northeast-1"
}

resource "aws_instance" "hello-world" {
  ami = "ami-0599b6e53ca798bb2" // console から確認、amazon linux 2023
  instance_type = "t2.micro"
  tags = {
    Name = "hello-terraform" // instance の名前
  }

  user_data = <<EOF
#!/bin/bash
amazon-linux-extras install nginx1.12 -y
systemctl start nginx
EOF
}