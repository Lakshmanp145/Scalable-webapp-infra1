locals {
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    alb_name = "app-${var.environment}-app-alb"
    public_subnet_ids = split(",", data.aws_ssm_parameter.public_subnet_ids.value)
    app_alb_sg_id = data.aws_ssm_parameter.alb_sg_id.value
    aws_alb_certificate_arn = data.aws_ssm_parameter.aws_alb_certificate_arn.value
}