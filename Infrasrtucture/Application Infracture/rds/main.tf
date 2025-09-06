module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = local.resource_name

  engine            = "postgres"
  engine_version    = "16.3"   # latest supported stable PG
  instance_class    = "db.t4g.micro"
  allocated_storage = 20

  db_name  = "transactions"
  username = "postgres"
  port     = "5432"
  password = "ExpenseApp1"
  manage_master_user_password = false
  skip_final_snapshot = true

  vpc_security_group_ids = [local.postgres_sg_id]

  # DB subnet group
  create_db_subnet_group = false
  db_subnet_group_name   = local.database_subnet_group_name

  # DB parameter group
  family = "postgres16"

  # Database Deletion Protection
  deletion_protection = false

  parameters = [
    {
      name  = "client_encoding"
      value = "UTF8"
    },
    {
      name  = "rds.force_ssl"
      value = "1"
    }
  ]

  tags = merge(
    var.common_tags,
    {
      Name = local.resource_name
    }
  )
}

resource "aws_route53_record" "postgres" {
  zone_id = var.zone_id
  name    = "postgres-${var.environment}.${var.domain_name}"
  type    = "CNAME"
  ttl     = 1
  records = [module.db.db_instance_address]
}
