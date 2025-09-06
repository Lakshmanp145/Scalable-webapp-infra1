locals {
  resource_name = "${var.project}-${var.environment}-backend"
  ami_id = data.aws_ami.joindevops.id
  private_subnet_id = split(",", data.aws_ssm_parameter.private_subnet_ids.value)[0]
  private_subnet_ids = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
  backend_sg_id = data.aws_ssm_parameter.backend_sg_id.value
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  app_alb_listener_arn = data.aws_ssm_parameter.app_alb_listener_arn.value
}