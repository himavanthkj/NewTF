variable "aws_region" {
    deafult = "us-east-1"
}

variable "vpc_cidr" {
    default = "10.20.0.0/16"
}

variable "subnets_cidr" {
    type = "list"
    default = ["10.20.1.0","10.20.2.0"]
}

variable "az" {
    type = "list"
    default = ["ap-south-1a","ap-south-1b"]
}

variable "ami_id" {
    default = "ami-04db49c0fb2215364"
}

variable "instance_type" {
    default = t2.micro
}

variable "number-instances" {
    default = "1"
}

variable "key" {
    default = "hima_sample"
}
