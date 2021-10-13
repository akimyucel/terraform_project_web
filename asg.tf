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