

data "aws_ssm_parameter" "mysql_sg_id" {
    name = "/${var.project}/${var.environment}/mysql_sg_id"
}

data "aws_ssm_parameter" "pubilc_subnet_id" {
    name = "/${var.project}/${var.environment}/public_subnet_ids"
}

data "aws_ssm_parameter" "database_subnet_group_name" {
    name = "/${var.project}/${var.environment}/database_subnet_group_name"
}