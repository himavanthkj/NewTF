provider "aws" {
    region = var.aws_region
}

resource "aws_vpc" "my_vpc" {
    cidr_block = var.vpc_cidr
    tags    =   {
        name    = "my_vpc"
    }
}

resource "aws_internet_gateway" "my_ig" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        Name    = "main"
    }
}
resource "aws_subnet" "public_subnet" {
    count   =   length(var.subnets_cidr)
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = element(var.subnets_cidr,count.index)
    availability_zone = element(var.azs,count.index)
    tags    =   {
        Name    =   "Subnet-${count.index+1}"
    }

}

# Route table: Attach internet gateway
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.my_vpc.id

    route   =   {
        cidr_block  =   "0.0.0.0/0"
        gateway_id  =   aws_internet_gateway.my_ig.id
    }
    tags = {
      "Name" = "publicRoutetable"
    }
}

# Route table association with public subnets
resource "aws_route_table_association" "namea" {
  count = length(var.subnets_cidr)
  subnet_id = "element(aws_subnet_public.*.id,count.index)"
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "webservers_sg" {
  name = "allow httpd"
  description = "Allow httpd inbound traffic"
  vpc_id = aws_vpc.my_vpc.id
  ingress  {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  }

  resource "aws_instance" "webservers" {
    count   = var.number_instances
    ami = var.ami_id
    instance_type = var.instance_type

    security_groups = aws_security_group.webservers_sg.id
    subnet_id = element(aws_subnet.public_subnet.*.id,count.index)
    key_name = var.key
    tags = {
      "Name" = "Server-${count.index}"
    }
  }