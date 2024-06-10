provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "dev_key_pair" {
    key_name = var.dev_key_name
    source = "../../modules/util/keypair"
}

module "dev_s3" {
  source = "../../modules/web/s3"

  bucket_name          = "terraform-web-dev-minjun"
  index_document_suffix = "index.html"
  error_document_key   = "error.html"
  tag_environment      = "dev"
}



module "dev_cloudfront" {
  source = "../../modules/web/cloudfront"

  domain_name = module.dev_s3.bucket_domain_name
  bucket_id = module.dev_s3.bucket_id
  waf_id = module.dev_waf.waf_id
  tag_environment = "dev"
}

module "dev_waf" {
  source = "../../modules/web/waf"

}


