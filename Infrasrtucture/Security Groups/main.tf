module "alb_sg" {
  source      = "git::https://github.com/Lakshmanp145/terraform-sg-module.git?ref=main"
  project     = var.project
  environment = var.environment
  description = "Created for ALB in expense dev"
  common_tags = var.common_tags
  vpc_id      = local.vpc_id
  sg_name     = "alb"
}

module "bastion_sg" {
  source      = "git::https://github.com/Lakshmanp145/terraform-sg-module.git?ref=main"
  project     = var.project
  environment = var.environment
  description = "Created for bastion instances in expense dev"
  common_tags = var.common_tags
  vpc_id      = local.vpc_id
  sg_name     = "bastion"
}

module "ec2_sg" {
  source      = "git::https://github.com/Lakshmanp145/terraform-sg-module.git?ref=main"
  project     = var.project
  environment = var.environment
  description = "Created for backend EC2 in expense dev"
  common_tags = var.common_tags
  vpc_id      = local.vpc_id
  sg_name     = "ec2_instance"
}

module "rds_sg" {
  source      = "git::https://github.com/Lakshmanp145/terraform-sg-module.git?ref=main"
  project     = var.project
  environment = var.environment
  description = "Created for RDS in expense dev"
  common_tags = var.common_tags
  vpc_id      = local.vpc_id
  sg_name     = "rds_database"
}

# ---------------- ALB Rules ----------------

# ALB: Allow HTTPS from Internet
resource "aws_security_group_rule" "alb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.alb_sg.sg_id
}

# ALB: Allow HTTP from Internet
resource "aws_security_group_rule" "alb_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.alb_sg.sg_id
}

# ---------------- EC2 Rules ----------------

# EC2: Allow Flask traffic (5000) from ALB only
resource "aws_security_group_rule" "ec2_flask" {
  type                     = "ingress"
  from_port                = 5000
  to_port                  = 5000
  protocol                 = "tcp"
  source_security_group_id = module.alb_sg.sg_id
  security_group_id        = module.ec2_sg.sg_id
}

# EC2: Allow SSH only from Bastion
resource "aws_security_group_rule" "ec2_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id        = module.ec2_sg.sg_id
}

# ---------------- RDS Rules ----------------

# RDS: Allow access only from EC2 instances
resource "aws_security_group_rule" "rds" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = module.ec2_sg.sg_id
  security_group_id        = module.rds_sg.sg_id
}

# ---------------- Bastion Rules ----------------

# Bastion host: Allow SSH only from your IP
resource "aws_security_group_rule" "bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] 
  security_group_id = module.bastion_sg.sg_id
}

#======================================
# EKS
#======================================

module "ingress_alb_sg" {
    source = "git::https://github.com/Lakshmanp145/terraform-sg-module.git?ref=main"
    project = var.project
    environment = var.environment
    description = "Created for backend Alb in expense dev"
    common_tags = var.common_tags
    vpc_id = local.vpc_id
    sg_name = "app-alb"
}

module "eks_control_plane_sg" {
    source = "git::https://github.com/Lakshmanp145/terraform-sg-module.git?ref=main"
    project = var.project
    environment = var.environment
    description = "Created for eks-control-plane"
    common_tags = var.common_tags
    vpc_id = local.vpc_id
    sg_name  = "eks-control-plane"
}

module "eks_node_sg" {
    source = "git::https://github.com/Lakshmanp145/terraform-sg-module.git?ref=main"
    project = var.project
    environment = var.environment
    description = "Created for eks-nodes"
    common_tags = var.common_tags
    vpc_id = local.vpc_id
    sg_name = "eks-node"
}

resource "aws_security_group_rule" "eks_control_plane_eks_node" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = module.eks_node_sg.sg_id
  security_group_id = module.eks_control_plane_sg.sg_id
}

resource "aws_security_group_rule" "eks_node_eks_control_plane" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = module.eks_control_plane_sg.sg_id
  security_group_id = module.eks_node_sg.sg_id
}

#App ALB accetping traffic from bastion host or jump host
resource "aws_security_group_rule" "ingress_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id = module.ingress_alb_sg.sg_id
}


#App ALB accetping traffic from bastion host or jump host
resource "aws_security_group_rule" "ingress_alb_bastion_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id = module.ingress_alb_sg.sg_id
}

resource "aws_security_group_rule" "ingress_alb_public_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.ingress_alb_sg.sg_id
}

resource "aws_security_group_rule" "node_vpc" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = module.eks_node_sg.sg_id
}

resource "aws_security_group_rule" "node_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id = module.eks_node_sg.sg_id
}


resource "aws_security_group_rule" "postgres_bastion" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id = module.rds_sg.sg_id
}

resource "aws_security_group_rule" "postgres_eks_node" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  source_security_group_id = module.eks_node_sg.sg_id
  security_group_id = module.rds_sg.sg_id
}

resource "aws_security_group_rule" "eks_control_plane_bastion" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id = module.eks_control_plane_sg.sg_id
}

resource "aws_security_group_rule" "eks_node_ingress_alb" {
  type              = "ingress"
  from_port         = 5000
  to_port           = 5000
  protocol          = "tcp"
  source_security_group_id = module.ingress_alb_sg.sg_id
  security_group_id = module.eks_node_sg.sg_id
}