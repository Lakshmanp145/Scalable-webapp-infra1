module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name    = local.alb_name
  vpc_id  = local.vpc_id 
  subnets = local.private_subnet_ids
  create_security_group = false
  security_groups = [local.app_alb_sg_id]
  enable_deletion_protection = false   # If protection is true we can't delete ALB through terraform
  internal = true
  # Security Group
  tags = merge(
    var.common_tags,
    {
        Name = local.alb_name
    }
  )
}

resource "aws_route53_record" "app_alb" {
  zone_id = var.zone_id
  name    = "*.app-dev.${var.domain_name}"
  type    = "A"

#Application ALB details
  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = false
  }
}