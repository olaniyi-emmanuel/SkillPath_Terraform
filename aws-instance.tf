variable "aws_ami_app_server" {
    
  
}

provider "aws" {
    region = "us-east-1" 
     
}

resource "aws_instance" "websever" {
  ami = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"
  tags = {
    name = "web-server"
  }
}

resource "aws_s3_bucket" "picture" {
    bucket = "app-picture"
  
}

resource "aws_eip" "lb" {
    instance = aws_instance.websever.id
  
}
  
