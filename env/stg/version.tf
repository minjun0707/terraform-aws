terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 0.12"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "minjun0707-terraform"

    workspaces {
      name = "terraform-aws-stg"
    }
  }
}
