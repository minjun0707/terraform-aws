terraform {
  cloud {
    organization = "minjun0707-terraform"
    workspaces {
      name = "terraform-aws"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.28.0"
    }
  }
  required_version = ">= 1.1.0"
}

provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_s3_bucket" "aws_s3_bucket" {
  bucket = "terrafrom-bucket" # 원하는 버킷 이름으로 변경

  tags = {
    Environment = "dev"
  }
}
