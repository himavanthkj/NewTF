terraform {
  backend "s3" {
    bucket = "himatfbackend"
    key    = terraform.state
    region = "us-west-2"
  }
}
