resource "aws_s3_bucket" "terrafrom-bucket-mj" {
  bucket = "terrafrom-bucket-mj"
  acl = "public-read-write"

  tags = {
    Environment = "dev"
  }
}


# 버킷 정책
resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.terrafrom-bucket-mj.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}


# CORS 규칙 설정
resource "aws_s3_bucket_cors_configuration" "test" {
  bucket = aws_s3_bucket.test.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["https://s3-website-test.hashicorp.com"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}

# 정적 웹 사이트 호스팅
resource "aws_s3_bucket_website_configuration" "test" {
  bucket = aws_s3_bucket.test.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  routing_rule {
    condition {
      key_prefix_equals = "docs/"
    }
    redirect {
      replace_key_prefix_with = "documents/"
    }
  }
