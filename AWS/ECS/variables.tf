variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_id" {
  default = "vpc-0a12fab7c3e926c65"
}

variable "docker_registry" {
  default = "nginx"
}

variable "app_family" {
  default = "hima"
  
}
variable "app_name" {
  default = "hima-app"
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
    default = "nginx"
}

variable "environment" {
  default = "my-den"
}

variable "platform_version" {
  description = "Fargate platform version"
}

variable "tag" {
  description = "tag of the docker image to be deployed"
  default     = "latest"
}

variable "domain_name" {
  default = "himavanth.net"
}

variable "awslogs_group" {
  default = "/ecs/himavanths"
}

variable "ecs_cluster" {
  default = "hima-ecs"
}

# variable "awslogs_stream_prefix" {
#   default = "clp" 
# }
variable "fargate_port" {
  description = "Port exposed by fargate"
  default     = 8080
}

variable "container_port" {
  description = "Service Port in docker"
  default     = 8080
}

variable "replica_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = 512
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = 1024
}


#variable "ssm_arn" {
#  default = "arn:aws:ssm:us-east-1:9iduvnuwef:parameter"
#}


variable "service_discovery_name" {
  default = "himas-nginx"
}
