output "vpc_id" {
  value = module.vpc.vpc_id
}

output "sg_alb_id" {
  value = aws_security_group.alb_sg.id
}

output "sg_was" {
  value = aws_security_group.was_sg.id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnets
}