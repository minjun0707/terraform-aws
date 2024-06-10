variable "alb_sg_id" {
  type        = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type        = list(string)
}


variable "tag_environment" {
  description = "The Environment tag for the S3 bucket"
  type        = string
}