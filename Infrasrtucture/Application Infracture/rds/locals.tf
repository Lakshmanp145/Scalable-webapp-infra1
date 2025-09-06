locals {
    resource_name = "${var.environment}-${var.db_engine}-rds"
    rds_sg_id = data.aws_ssm_parameter.rds_sg_id.value
    database_subnet_group_name = data.aws_ssm_parameter.database_subnet_group_name.value
    db_password=data.aws_ssm_parameter.db_password.value
    db_username=data.aws_ssm_parameter.db_username.value
    db_name=data.aws_ssm_parameter.db_name.value
}