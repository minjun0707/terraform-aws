resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "aws_keypair" {
  key_name   = var.key_name
  public_key = tls_private_key.private_key.public_key_openssh
}

resource "local_file" "private_key_pem" {
  content  = tls_private_key.private_key.private_key_pem
  filename = "${path.root}/keypair/${var.key_name}.pem"
}

# output "private_key_pem" {
#   description = "The private key in PEM format"
#   value       = tls_private_key.private_key.private_key_pem
#   sensitive   = true
# }

# output "aws_key_pair" {
#   description = "The name of the key pair"
#   value       = aws_key_pair.aws_keypair.key_name
# }

