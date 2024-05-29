
terraform {
#    cloud {
#      organization = "minjun0707-terraform"         # 생성한 ORG 이름 지정
#      hostname     = "app.terraform.io"      # default

#      workspaces {
#        name = "terraform-aws"  # 없으면 생성됨
#      }
#    }
  required_version = "~> 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
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
