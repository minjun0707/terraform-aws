provider "aws" {
  region = var.aws_region
}

module "keypair" {
  source = "./util/keypair"
}