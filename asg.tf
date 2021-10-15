resource "aws_autoscaling_policy" "web_asg_scaleup" {
  name                   = replace(local.name, "rtype", "CPU_Utilization40")
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web.name
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm40" {
  alarm_name                = replace(local.name, "rtype", "cpu-alarm40")
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "40"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }

  alarm_actions = [aws_autoscaling_policy.web_asg_scaleup.arn]
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm60" {
  alarm_name                = replace(local.name, "rtype", "cpu-alarm60")
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "60"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }

  alarm_actions = [aws_autoscaling_policy.web_asg_scaleup.arn]
}


resource "aws_autoscaling_group" "web" {
  name                      = replace(local.name, "rtype", "asg")
  max_size                  = var.asg_max
  min_size                  = var.asg_desired
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = var.asg_desired
  force_delete              = var.env == "dev" ? true : false
  launch_configuration      = aws_launch_configuration.web.name
  vpc_zone_identifier       = var.subnets

  tag {
    key                 = "Name"
    value               = replace(local.name, "rtype", "asg")
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = local.tags
    iterator = tag
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}