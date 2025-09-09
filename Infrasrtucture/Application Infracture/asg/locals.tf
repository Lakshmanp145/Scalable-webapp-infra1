locals {
  resource_name = "${var.environment}-asg"
  ami_id = data.aws_ami.python-flask.id
  private_subnet_id = split(",", data.aws_ssm_parameter.private_subnet_ids.value)[0]
  private_subnet_ids = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
  ec2_sg_id = data.aws_ssm_parameter.ec2_sg_id.value
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  app_alb_listener_arn = data.aws_ssm_parameter.app_alb_listener_arn.value
  #app_alb_listener_arn_http = data.aws_ssm_parameter.app_alb_listener_arn_http.value
}