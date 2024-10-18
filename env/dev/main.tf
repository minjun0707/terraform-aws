provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "dev_key_pair" {
    key_name = var.dev_key_name
    source = "../../modules/util/keypair"
}

module "dev_s3" {
  source = "../../modules/web/s3"

  bucket_name          = var.dev_bucket_name
  index_document_suffix = "index.html"
  error_document_key   = "error.html"
  tag_environment      = "dev"
}


module "dev_cloudfront" {
  source = "../../modules/web/cloudfront"

  domain_name = module.dev_s3.bucket_domain_name
  bucket_id = module.dev_s3.bucket_id
  waf_id = module.dev_waf.waf_id
  tag_environment = var.dev_tag
}

module "dev_waf" {
  source = "../../modules/web/waf"
}

module "dev_network" {
  source          = "../../modules/network"
  tag_environment = var.dev_tag
}


module "dev_alb" {
  source = "../../modules/alb"

  vpc_id            = module.dev_network.vpc_id
  alb_sg_id         = module.dev_network.sg_alb_id
  public_subnet_ids = module.dev_network.public_subnet_ids
  tag_environment   = var.dev_tag
}

module "dev_was" {
  source = "../../modules/was"

  sg_was           = module.dev_network.sg_was
  target_group_arn = module.dev_alb.target_group_arn
  public_subnet_ids = module.dev_network.public_subnet_ids
  tag_environment   = var.dev_tag
}
