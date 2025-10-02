provider "aws" {
  region = "us-east-1"
}

module "network" {
  source      = "./modules/network"
  vpc_cidr    = "10.0.0.0/16"
  subnet_cidr = "10.0.1.0/24"
  name        = "my-vpc"
}
