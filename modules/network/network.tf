module "vpc" {
  source  = "terraform-aws-modules/vpc/aws" #사용할 Module 지정
  version = "~> 4.0"  # 최신 버전을 확인하고 사용하세요

  name = "vpc"                              #VPC 이름 지정
  cidr = "10.0.0.0/16"                      #IPv4 CIDR

  azs             = ["ap-northeast-2a"]
  public_subnets  = ["10.0.10.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]
 
  enable_nat_gateway = true			#NAT Gateway 활성
  single_nat_gateway = true         #단일 NAT Gateway 설정
  one_nat_gateway_per_az = false    #단일 NAT 설정 시 false로 비활성화

  tags = { Terraform = "true"
    Environment = "dev" }                   #태그 설정
}