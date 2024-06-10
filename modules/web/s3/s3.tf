# S3 버킷
resource "aws_s3_bucket" "www_bucket" {
  bucket = var.bucket_name

  tags = {
    Environment = var.tag_environment
  }
}


## 정적 웹사이트 호스팅
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.www_bucket.id

  index_document {
    suffix = var.index_document_suffix
  }

  error_document {
    key = var.error_document_key
  }
}


# 퍼블릭 액세스 차단 해제 비활성화
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.www_bucket.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

# CORS 규칙 설정
resource "aws_s3_bucket_cors_configuration" "cors_config" {
  bucket = aws_s3_bucket.www_bucket.id

  cors_rule {
    allowed_headers = var.allowed_headers
    allowed_methods = var.allowed_methods
    allowed_origins = var.allowed_origins
    expose_headers  = var.expose_headers
    max_age_seconds = var.max_age_seconds
  }

  cors_rule {
    allowed_methods = var.allowed_methods_get_only
    allowed_origins = var.allowed_origins
  }
}

# 버킷 정책 설정
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.www_bucket.id

  depends_on = [aws_s3_bucket_public_access_block.public_access_block]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "PublicRead"
        Effect = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject"
        ]
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.www_bucket.id}/*"
        ]
      }
    ]
  })
}

# S3 버킷에 파일 업로드
resource "aws_s3_object" "files" {
  for_each = fileset("../../client/build", "**")

  bucket = aws_s3_bucket.www_bucket.id
  key    = each.value
  source = "../../client/build/${each.value}"
  etag   = filemd5("../../client/build/${each.value}")
}

# index.html 파일 업로드
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.www_bucket.id
  key          = "index.html"
  source       = "../../client/build/index.html"
  content_type = "text/html"
}

