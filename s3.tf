# S3 버킷
resource "aws_s3_bucket" "www_bucket" {
  bucket = "terraform-bucket-mj-test"

  tags = {
    Environment = "dev"
  }

}

## 정적 웹사이트 호스팅
resource "aws_s3_bucket_website_configuration" "websit_config" {
  bucket = aws_s3_bucket.www_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}

# 퍼블릭 액세스 차단 해제 비활성화
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.www_bucket.id

  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls  = false
  restrict_public_buckets = false
}

# CORS 규칙 설정
resource "aws_s3_bucket_cors_configuration" "cors_config" {
  bucket = aws_s3_bucket.www_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT","POST","GET"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}

# 버킷 정책 설정
resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.www_bucket.id

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"PublicRead",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::${aws_s3_bucket.www_bucket.id}/*"]
    }
  ]
}
POLICY
}
