# resource "aws_security_group" "web_sg" {
#   name        = "was_sg"
#   vpc_id      = module.vpc.vpc_id
#   # 인바운드 규칙
#   ingress {
#     description      = "Allow HTTP"
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     ## ALB ip로 변경
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   ingress {
#     description      = "Allow SSH"
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   # 아웃바운드 규칙
#   egress {
#     description      = "Allow all outbound traffic"
#     from_port        = 0
#     to_port          = 0
    
#     protocol         = "-1"  # 모든 프로토콜
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   tags = {
#     Environment = var.tag_environment
#   }
# }


resource "aws_security_group" "alb_sg" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.tag_environment
  }
}



resource "aws_security_group" "was_sg" {
  name        = "was_sg"
  vpc_id      = module.vpc.vpc_id
  # 인바운드 규칙
  ingress {
    description      = "Allow HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    ## ALB ip로 변경
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # 아웃바운드 규칙
  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    
    protocol         = "-1"  # 모든 프로토콜
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.tag_environment
  }
}