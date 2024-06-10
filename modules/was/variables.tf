variable "public_subnet_ids" {
  type        = list(string)
}


variable "tag_environment" {
  type        = string
}

variable "sg_was" {
  type = string
}

variable "target_group_arn" {
  type = string
}