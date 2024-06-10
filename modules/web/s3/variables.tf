variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}


variable "tag_environment" {
  description = "The Environment tag for the S3 bucket"
  type        = string
}



variable "index_document_suffix" {
  description = "The suffix for the index document"
  type        = string
}

variable "error_document_key" {
  description = "The key for the error document"
  type        = string
}




variable "block_public_acls" {
  description = "Whether to block public ACLs"
  type        = bool
  default     = false
}

variable "block_public_policy" {
  description = "Whether to block public policies"
  type        = bool
  default     = false
}

variable "ignore_public_acls" {
  description = "Whether to ignore public ACLs"
  type        = bool
  default     = false
}

variable "restrict_public_buckets" {
  description = "Whether to restrict public buckets"
  type        = bool
  default     = false
}




variable "allowed_headers" {
  description = "Allowed headers for CORS configuration"
  type        = list(string)
  default     = ["*"]
}

variable "allowed_methods" {
  description = "Allowed methods for CORS configuration"
  type        = list(string)
  default     = ["PUT", "POST", "GET"]
}

variable "allowed_methods_get_only" {
  description = "Allowed GET method for CORS configuration"
  type        = list(string)
  default     = ["GET"]
}

variable "allowed_origins" {
  description = "Allowed origins for CORS configuration"
  type        = list(string)
  default     = ["*"]
}

variable "expose_headers" {
  description = "Expose headers for CORS configuration"
  type        = list(string)
  default     = ["ETag"]
}

variable "max_age_seconds" {
  description = "Max age for CORS configuration"
  type        = number
  default     = 3000
}
