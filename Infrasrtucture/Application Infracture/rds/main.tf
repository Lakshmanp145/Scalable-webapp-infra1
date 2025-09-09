##############################
# IAM Role for RDS Monitoring
##############################
resource "aws_iam_role" "rds_monitoring" {
  name = "rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds_monitoring_attach" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

##############################
# RDS Module
##############################
module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.0"

  identifier = local.resource_name

  engine            = "postgres"
  engine_version    = "15"
  instance_class    = "db.t4g.micro"
  allocated_storage = 20

  db_name  = local.db_name
  username = local.db_username
  password = local.db_password
  port     = 5432

  manage_master_user_password = false
  deletion_protection         = false
  skip_final_snapshot         = false

  # 🔹 Automated backups
  backup_retention_period = 7
  backup_window           = "02:00-03:00"

  # 🔹 Enable enhanced monitoring
  monitoring_interval = 60
  monitoring_role_arn = aws_iam_role.rds_monitoring.arn

  vpc_security_group_ids = [data.aws_ssm_parameter.rds_sg_id.value]

  create_db_subnet_group = false
  db_subnet_group_name   = local.database_subnet_group_name

  family               = "postgres15"
  major_engine_version = "15"
 


  parameters = [
    {
      name  = "log_statement"
      value = "all"
    },
    {
      name  = "log_min_duration_statement"
      value = "5000"
    },
    {
      # 🔹 Control SSL requirement
      name  = "rds.force_ssl"
      value = "0" # set to 1 to enforce SSL, 0 to make it optional
    }
  ]

  tags = merge(
    var.common_tags,
    {
      Name = local.resource_name
    }
  )
}

##############################
# Optional: Route53 DNS
##############################
resource "aws_route53_record" "db" {
  zone_id = var.zone_id
  name    = "postgres-${var.environment}.${var.domain_name}"
  type    = "CNAME"
  ttl     = 60
  records = [module.db.db_instance_address]
}
