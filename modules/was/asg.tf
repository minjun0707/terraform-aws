resource "aws_autoscaling_group" "asg_group" {
  name                 = "was-asg"
  launch_configuration = aws_launch_configuration.was_launchconfig.name
  vpc_zone_identifier  = var.public_subnet_ids

  # ELB 연결
  health_check_type = "ELB"
  target_group_arns = [var.target_group_arn]

  min_size = 2
  max_size = 4

  tag {
    key                 = "Environment"
    value               = var.tag_environment
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "was_launchconfig" {
  name_prefix     = "t101-lauchconfig-"
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  security_groups = [var.sg_was]
  associate_public_ip_address = true

#   user_data = <<-EOF
#               #!/bin/bash
#               wget https://busybox.net/downloads/binaries/1.31.0-defconfig-multiarch-musl/busybox-x86_64
#               mv busybox-x86_64 busybox
#               chmod +x busybox
#               RZAZ=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone-id)
#               IID=$(curl 169.254.169.254/latest/meta-data/instance-id)
#               LIP=$(curl 169.254.169.254/latest/meta-data/local-ipv4)
#               echo "<h1>RegionAz($RZAZ) : Instance ID($IID) : Private IP($LIP) : Web Server</h1>" > index.html
#               nohup ./busybox httpd -f -p 80 &
#               EOF

  # Required when using a launch configuration with an auto scaling group.
  lifecycle {
    create_before_destroy = true
  }
}