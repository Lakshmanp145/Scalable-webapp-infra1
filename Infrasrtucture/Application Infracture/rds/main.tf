module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = local.resource_name

  engine            = "postgres"
  engine_version    = "15"                # Latest supported Postgres
  instance_class    = "db.t4g.micro"
  allocated_storage = 20

  db_name  = local.db_name            
  username = local.db_username
  password = local.db_password                 
  port     = 5432

  manage_master_user_password = false
  skip_final_snapshot         = true
  deletion_protection         = false

  vpc_security_group_ids = [data.aws_ssm_parameter.rds_sg_id.value]

  # DB subnet group
  create_db_subnet_group = false
  db_subnet_group_name   = local.database_subnet_group_name

  # DB parameter group
  family = "postgres15"

  # Option group (only for engines like MySQL/Oracle, skip for Postgres)
  major_engine_version = "15"

  parameters = [
    {
      name  = "log_statement"
      value = "all"
    },
    {
      name  = "log_min_duration_statement"
      value = "5000" # log queries >5s
    }
  ]

  tags = merge(
    var.common_tags,
    {
      Name = local.resource_name
    }
  )
}

# Optional: DNS Record for internal app usage
resource "aws_route53_record" "db" {
  zone_id = var.zone_id
  name    = "postgres-${var.environment}.${var.domain_name}"
  type    = "CNAME"
  ttl     = 60
  records = [module.db.db_instance_address]
}
