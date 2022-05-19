data "aws_vpc" "default" {
  id = var.vpc_id
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
  tags = {
    type = "internal"
  }
}

#data "aws_iam_role" "ecs_task_execution_role" {
#  name = "ecs_task_execution_role"
#}

 #data "aws_iam_role" "ecs_task_role" {
  # name = "task_role"
 #}

data "aws_ecs_cluster" "hima-ecs" {
  cluster_name = var.ecs_cluster
}

#data "aws_route53_zone" "namespace" {
 # name         = "hima-.int."
  #private_zone = true
#}

#data "terraform_remote_state" "ecs" {
 # backend = "s3"
 # config = {
  #  bucket = "terraform-state"
    # path to resources
#    key = "ecs/terraform.tfstate"
 #   profile = "cloud_user"
  #  region = "us-east-1"
  #}
#}


data "aws_security_group" "default-sg" {
  name = "default"
}
