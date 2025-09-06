locals {
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    alb_name = "${var.project}-${var.environment}-app-alb"
    private_subnet_ids = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
    app_alb_sg_id = data.aws_ssm_parameter.app_alb_sg_id.value
}