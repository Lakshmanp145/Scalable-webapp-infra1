module "alb_sg" {
    source = "git::https://github.com/Lakshmanp145/terraform-sg-module.git?ref=main"
    project = var.project
    environment = var.environment
    description = "Created for mysql instances in expense dev"
    common_tags = var.common_tags
    vpc_id = local.vpc_id
    sg_name = var.sg_name
}
  

module "bastion_sg" {
    source = "git::https://github.com/Lakshmanp145/terraform-sg-module.git?ref=main"
    project = var.project
    environment = var.environment
    description = "Created for bastion instances in expense dev"
    common_tags = var.common_tags
    vpc_id = local.vpc_id
    sg_name = "bastion"
}

module "ec2_sg" {
    source = "git::https://github.com/Lakshmanp145/terraform-sg-module.git?ref=main"
    project = var.project
    environment = var.environment
    description = "Created for backend Alb in expense dev"
    common_tags = var.common_tags
    vpc_id = local.vpc_id
    sg_name = "app-alb"
}


module "rds_sg" {
    source = "git::https://github.com/Lakshmanp145/terraform-sg-module.git?ref=main"
    project = var.project
    environment = var.environment
    description = "Created for eks-control-plane"
    common_tags = var.common_tags
    vpc_id = local.vpc_id
    sg_name  = "eks-control-plane"
}

# ALB: Allow HTTPS from internet
resource "aws_security_group_rule" "alb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.alb_sg.sg_id
}

# ALB: Allow HTTP from internet
resource "aws_security_group_rule" "alb_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.alb_sg.sg_id
}

# EC2: Allow traffic only from ALB (HTTP) 
resource "aws_security_group_rule" "ec2_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.alb_sg.sg_id  # only ALB can reach EC2
  security_group_id        = module.ec2_sg.sg_id
}

# EC2: Allow traffic only from Bastion (SSH)
resource "aws_security_group_rule" "ec2_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion_sg.sg_id # only Bastion can SSH
  security_group_id        = module.ec2_sg.sg_id
}

# RDS: Allow access only from EC2
resource "aws_security_group_rule" "rds" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = module.ec2_sg.sg_id  # only EC2 instances
  security_group_id        = module.rds_sg.sg_id
}

# Bastion host: Allow SSH only from your IP
resource "aws_security_group_rule" "bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.my_ip]   
  security_group_id = module.bastion_sg.sg_id
}
