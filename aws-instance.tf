provider "aws" {
    region = var.aws_region
    
}

#VPC
resource "aws_vpc" "name" {
  cidr_block = var.vpc_cidr
  tags = {
    name = var.aws_vpc_name
  }
}

#Public Subnet
resource "aws_subnet" "Public" {  
    vpc_id = aws_vpc.name.id
    count = length(var.subnet_cidr)
    cidr_block = element(var.subnet_cidr, count.index)
    availability_zone = element(var.azs, count.index)
  
}

#internet gateway
resource "aws_internet_gateway" "name" {
  vpc_id = aws_vpc.name.id
  tags = {
    name = var.aws_igw_name
  }
}

#Route table attach internet gateway
resource "aws_route_table" "name" {
  vpc_id = aws_vpc.name.id
}

resource "aws_route" "name" {
  route_table_id         = aws_route_table.name.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.name.id
}


#route table association with public subnets
resource "aws_route_table_association" "a" {
  count = length(var.subnet_cidr)
  subnet_id = element(aws_subnet.Public.*.id, count.index)
  route_table_id = aws_route_table.name.owner_id
}

#webserver ec2 instance 
resource "aws_instance" "websever" {
  ami = var.aws_ami_webserver
  instance_type = var.aws_instance_type
  availability_zone = var.azs.0
  subnet_id = aws_subnet.Public.0.id
  associate_public_ip_address = true
  tags = {
    name = var.aws_instance_name
  }
}

#ebs volume attached 
resource "aws_ebs_volume" "name1" {
  availability_zone = var.ebs_az
  size              = 10        
}

#AWS Volume attachment for volume 1
resource "aws_volume_attachment" "name1" {
  device_name = var.volume_device_name1
  volume_id = aws_ebs_volume.name1.id
  instance_id = aws_instance.websever.id
}




  
