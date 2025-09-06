data "aws_ssm_parameter" "vpc_id" {
    name = "/${var.project}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
    name = "/${var.project}/${var.environment}/private_subnet_ids"
}

data "aws_ssm_parameter" "app_alb_sg_id" {
    name = "/${var.project}/${var.environment}/app_alb_sg_id"
}