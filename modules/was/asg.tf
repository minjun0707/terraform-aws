resource "aws_launch_template" "was_launchtemplate" {
  name_prefix   = "t101-launchtpl-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.sg_was]
  }

#   user_data = <<-EOF
#     #!/bin/bash
#     wget https://busybox.net/downloads/binaries/1.31.0-defconfig-multiarch-musl/busybox-x86_64
#     mv busybox-x86_64 busybox
#     chmod +x busybox
#     RZAZ=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone-id)
#     IID=$(curl 169.254.169.254/latest/meta-data/instance-id)
#     LIP=$(curl 169.254.169.254/latest/meta-data/local-ipv4)
#     echo "<h1>RegionAz($RZAZ) : Instance ID($IID) : Private IP($LIP) : Web Server</h1>" > index.html
#     nohup ./busybox httpd -f -p 80 &
#     EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg_group" {
  name                 = "was-asg"
  vpc_zone_identifier  = var.public_subnet_ids

  # ELB 연결
  health_check_type = "ELB"
  target_group_arns = [var.target_group_arn]

  min_size = 2
  max_size = 4

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.was_launchtemplate.id
        version            = "$Latest"
      }

      override {
        instance_type = "t2.micro"
      }
    }

    instances_distribution {
      on_demand_base_capacity                = 2
      on_demand_percentage_above_base_capacity = 0
      spot_allocation_strategy               = "lowest-price"
    }
  }

  termination_policies = ["OldestInstance", "Default"]

  tag {
    key                 = "Environment"
    value               = var.tag_environment
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_out_policy" {
  name                   = "scale-out-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60

  autoscaling_group_name = aws_autoscaling_group.asg_group.name
}

resource "aws_autoscaling_policy" "scale_in_policy" {
  name                   = "scale-in-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300

  autoscaling_group_name = aws_autoscaling_group.asg_group.name
}

resource "aws_cloudwatch_metric_alarm" "scale_out_alarm" {
  alarm_name                = "cpu-utilization-high"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 1
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 70

  alarm_description         = "This alarm triggers when the CPU utilization exceeds 70% for 1 minute"
  dimensions                = {
    AutoScalingGroupName = aws_autoscaling_group.asg_group.name
  }

  alarm_actions             = [aws_autoscaling_policy.scale_out_policy.arn]
}

resource "aws_cloudwatch_metric_alarm" "scale_in_alarm" {
  alarm_name                = "cpu-utilization-low"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = 1
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 300
  statistic                 = "Average"
  threshold                 = 40

  alarm_description         = "This alarm triggers when the CPU utilization is below 40% for 5 minutes"
  dimensions                = {
    AutoScalingGroupName = aws_autoscaling_group.asg_group.name
  }

  alarm_actions             = [aws_autoscaling_policy.scale_in_policy.arn]
}
