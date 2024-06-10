module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name = "vpc"
  cidr = "10.0.0.0/16"

  # 두 개의 가용 영역 지정
  azs             = ["ap-northeast-2a", "ap-northeast-2c"]

  # 각 가용 영역에 퍼블릭 서브넷 추가
  public_subnets  = ["10.0.10.0/24", "10.0.11.0/24"]
  private_subnets = ["10.0.20.0/24", "10.0.21.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  tags = { Environment = "dev" }
}
