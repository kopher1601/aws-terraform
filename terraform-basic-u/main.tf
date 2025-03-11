provider "aws" {
  profile = "default" // aws profile
  region = "ap-northeast-1"
}

resource "aws_instance" "hello-world" {
  ami = "ami-0599b6e53ca798bb2" // consoleから確認、amazon linux 2023
  instance_type = "t2.micro"
}