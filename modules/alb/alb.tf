resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids
  enable_deletion_protection = false

  tags = {
    Environment = var.tag_environment
  }
}

# 기본 HTTP 포트인 80번 포트 수신 
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port = 80
  protocol = "HTTP"

  # 리스너 규칙과 일치하지 않는 요청은 기본값인 단순한 404 페이지 오류를 반환
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code = 404
    }
  }
}

# HTTP 요청을 인스턴스에 주기적으로 요청 전송하여 인스턴스 상태 점검
resource "aws_lb_target_group" "tg" {
  name = "tg"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  } 
}


# target group을 listener와 연결
resource "aws_lb_listener_rule" "http_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}