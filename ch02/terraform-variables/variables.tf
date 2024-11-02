variable "filename" {
  default     = "/tmp/hello.txt"
  type        = string
  description = "local file name"
}

variable "content" {
  default = "Hello World!"
}

variable "server" {
  type = object({
    name          = string
    instance_type = string
    ami           = string
    subnet_id     = string
    security_group_ids = list(string)
    tags = map(string)
  })
  default = {
    name          = "my-server"
    instance_type = "t2.micro"
    ami           = "ami-xxxxxx"
    subnet_id     = "subnet-xxxxxx"
    security_group_ids = ["sg-xxxxx"]
    tags = {
      Environment = "production"
      Application = "my-app"
    }
  }
}

# tuple
variable "example_tuple" {
  type = tuple([string, number, bool])
  default = (["my_string", 23, true])
}

output "tuple_example" {
  value = var.example_tuple[0] // returns "my_string"
}

# set
variable "example_set" {
  type = set(string)
  default = ["v1", "v2", "v3"]
}

output "set_example" {
  value = var.example_set
}