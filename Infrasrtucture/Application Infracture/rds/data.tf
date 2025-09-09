

data "aws_ssm_parameter" "rds_sg_id" {
    name = "/${var.project}/${var.environment}/rds_sg_id"
}

data "aws_ssm_parameter" "pubilc_subnet_id" {
    name = "/${var.project}/${var.environment}/public_subnet_ids"
}

data "aws_ssm_parameter" "database_subnet_group_name" {
    name = "/${var.project}/${var.environment}/database_subnet_group_name"
}

data "aws_ssm_parameter" "db_password" {
    name = "/${var.db_engine}/${var.environment}/password"
}

data "aws_ssm_parameter" "db_username" {
    name = "/${var.db_engine}/${var.environment}/username"
}

data "aws_ssm_parameter" "db_name" {
    name = "/${var.project}/${var.environment}/db_name"
}

