resource "aws_waf_web_acl" "www_waf" {
  name        = "www-web-acl"
  metric_name = "WebACL"

  default_action {
    type = "ALLOW"
  }
}