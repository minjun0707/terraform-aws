provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_s3_bucket" "aws_s3_bucket" {
  bucket = "terrafrom-bucket"

  tags = {
    Environment = "dev"
  }
}
