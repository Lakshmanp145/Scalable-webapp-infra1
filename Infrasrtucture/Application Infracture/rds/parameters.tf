resource "aws_ssm_parameter" "rds_endpoint" {
  name        = "/${var.project}/${var.environment}/db-endpoint"
  description = "RDS endpoint for ${var.project}-${var.environment}"
  type        = "String"
  value       = module.db.db_instance_address
}