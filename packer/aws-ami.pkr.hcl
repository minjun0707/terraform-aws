packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "packer-aws-ami"
  instance_type = "t2.micro"
  region        = "ap-northeast-2"
  availability_zone = "ap-northeast-2a" 
  vpc_id = "vpc-0e3e7a11a29eabf3e"
  subnet_id = "subnet-0930b4793c1dc394e"
  source_ami    = "ami-0e6f2b2fa0ca704d0"  # 특정 AMI ID를 직접 지정
  ssh_username = "ubuntu"
}

build {
  name = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  hcp_packer_registry {
    bucket_name = "aws-ami-packer"
    description = "Description about the image being published."
  }

  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]
    inline = [
      "sleep 30",
      "sudo apt-get update",
      "sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io"
    ]
  }
}
