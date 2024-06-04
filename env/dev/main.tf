provider "aws" {
  region = var.aws_region
}

module "dev_key_pair" {
    source = "../../modules/util/keypair"
    
    key_name = var.dev_key_name
}