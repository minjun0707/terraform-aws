variable "domain_name" {
  type        = string
}


variable "bucket_id" {
  type        = string
}

variable "tag_environment" {
  description = "The Environment tag for the S3 bucket"
  type        = string
}

variable "waf_id" {
  type        = string
}
