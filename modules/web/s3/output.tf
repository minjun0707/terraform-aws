output "bucket_id" {
  value = aws_s3_bucket.www_bucket.id
}

output "bucket_endpoint" {
  value = aws_s3_bucket.www_bucket.website_endpoint
}

output "bucket_domain_name" {
  value = aws_s3_bucket.www_bucket.bucket_domain_name
}