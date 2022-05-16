provider "aws" {
  region = "us-east-1"
}

terraform {
  # specify the exact current version
  required_version = "0.12.29"

  backend "s3" {
    # one bucket for every aws-account
    bucket = "aws-terraform-state"
    # path to resources
    key    = "ecs/terraform.tfstate"
    region = "us-east-1"

    # one dynamodb table for every aws-account
    dynamodb_table = "terraform_locks"
  }
}
