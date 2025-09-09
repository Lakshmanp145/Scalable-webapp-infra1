# Target group for Flask app
resource "aws_lb_target_group" "backend" {
  name     = "${local.resource_name}-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  deregistration_delay = 60

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    protocol            = "HTTP"
    port                = "5000"
    path                = "/"
    matcher             = "200-299"
    interval            = 30
  }
}

# Launch template
# Launch template
resource "aws_launch_template" "backend" {
  name          = "${local.resource_name}-lt"
  image_id      = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.ec2_sg_id]
  update_default_version = true

  instance_initiated_shutdown_behavior = "terminate"

  # 🔹 Inject environment variables dynamically
  user_data = base64encode(<<-EOT
    #!/bin/bash
    cat > /etc/flaskapp.env <<EOF
    DB_HOST=${data.aws_ssm_parameter.db-endpoint.value}
    DB_NAME=${data.aws_ssm_parameter.db_name.value}
    DB_USER=${data.aws_ssm_parameter.db_username.value}
    DB_PASS=${data.aws_ssm_parameter.db_password.value}
    EOF

    systemctl daemon-reload
    systemctl restart flaskapp
  EOT
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${local.resource_name}-ec2"
    }
  }
}


# Autoscaling group
resource "aws_autoscaling_group" "backend" {
  name                      = "${local.resource_name}-asg"
  max_size                  = 4
  min_size                  = 1
  desired_capacity          = 2
  health_check_grace_period = 180
  health_check_type         = "ELB"

  target_group_arns = [aws_lb_target_group.backend.arn]
  vpc_zone_identifier = local.private_subnet_ids

  launch_template {
    id      = aws_launch_template.backend.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }

  timeouts {
    delete = "10m"
  }

  tag {
    key                 = "Name"
    value               = "${local.resource_name}-asg"
    propagate_at_launch = true
  }
}

# Scaling policy
resource "aws_autoscaling_policy" "backend" {
  name                   = "${local.resource_name}-policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.backend.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
  }
}

# Listener rules
resource "aws_lb_listener_rule" "backend_https" {
  listener_arn = local.app_alb_listener_arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }

  condition {
    host_header {
      values = ["app-web-${var.environment}.${var.domain_name}"]
    }
  }
}

# resource "aws_lb_listener_rule" "backend_http" {
#   listener_arn = local.app_alb_listener_arn_http
#   priority     = 10

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.backend.arn
#   }

#   condition {
#     host_header {
#       values = ["app-web-${var.environment}.${var.domain_name}"]
#     }
#   }
# }
