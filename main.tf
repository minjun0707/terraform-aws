resource "aws_s3_bucket" "aws_s3_bucket" {
  bucket = "terrafrom-bucket" # 원하는 버킷 이름으로 변경

  tags = {
    Environment = "dev"
  }
}
