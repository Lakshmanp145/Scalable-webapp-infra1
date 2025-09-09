data "aws_ami" "python-flask" {
  most_recent = true
  owners      = ["503561459301"]

  filter {
    name   = "name"
    values = ["python-flask"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ssm_parameter" "ec2_sg_id" {
    name = "/${var.project}/${var.environment}/ec2_sg_id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
    name = "/${var.project}/${var.environment}/private_subnet_ids"
}

data "aws_ssm_parameter" "vpc_id" {
    name = "/${var.project}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "app_alb_listener_arn" {
    name = "/${var.project}/${var.environment}/app_alb_listener_arn"
}


# data "aws_ssm_parameter" "app_alb_listener_arn_http" {
#     name = "/${var.project}/${var.environment}/app_alb_listener_arn_http"
# }

data "aws_ssm_parameter" "db_password" {
    name = "/${var.db_engine}/${var.environment}/password"
}

data "aws_ssm_parameter" "db_username" {
    name = "/${var.db_engine}/${var.environment}/username"
}

data "aws_ssm_parameter" "db_name" {
    name = "/${var.project}/${var.environment}/db_name"
}

data "aws_ssm_parameter" "db-endpoint" {
    name = "/${var.project}/${var.environment}/db-endpoint"
}