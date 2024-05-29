provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_s3_bucket" "terrafrom-bucket-mj" {
  bucket = "terrafrom-bucket-mj"

  tags = {
    Environment = "dev"
  }
}
