provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "stg_key_pair" {
    key_name = var.stg_key_name
    source = "../../modules/util/keypair"
}

module "stg_s3" {
  source = "../../modules/web/s3"

  bucket_name          = "terraform-web-stg-minjun"
  index_document_suffix = "index.html"
  error_document_key   = "error.html"
  tag_environment      = "stg"
}


module "stg_cloudfront" {
  source = "../../modules/web/cloudfront"

  domain_name = module.stg_s3.bucket_domain_name
  bucket_id = module.stg_s3.bucket_id
  waf_id = module.stg_waf.waf_id
  tag_environment = "stg"
}

module "stg_waf" {
  source = "../../modules/web/waf"
}

module "stg_network" {
  source          = "../../modules/network"
  tag_environment = "stg"
}


module "stg_alb" {
  source = "../../modules/alb"

  vpc_id            = module.stg_network.vpc_id
  alb_sg_id         = module.stg_network.sg_alb_id
  public_subnet_ids = module.stg_network.public_subnet_ids
  tag_environment   = "stg"
}

module "stg_was" {
  source = "../../modules/was"

  sg_was           = module.stg_network.sg_was
  target_group_arn = module.stg_alb.target_group_arn
  public_subnet_ids = module.stg_network.public_subnet_ids
  tag_environment   = "stg"
}
