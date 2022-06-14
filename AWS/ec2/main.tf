provider "aws" {
  region  = "us-east-1"
}

resource "aws_instance" "foo" {
  ami           = "ami-0022f774911c1d690" # us-east-`
  instance_type = "t2.micro"

}
