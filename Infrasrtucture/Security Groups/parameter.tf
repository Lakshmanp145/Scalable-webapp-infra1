resource "aws_ssm_parameter" "alb_sg_id" {
  name  = "/${var.project}/${var.environment}/alb_sg_id"
  type  = "String"
  value = module.alb_sg.sg_id
}


resource "aws_ssm_parameter" "bastion_sg_id" {
  name  = "/${var.project}/${var.environment}/bastion_sg_id"
  type  = "String"
  value = module.bastion_sg.sg_id
}

resource "aws_ssm_parameter" "ec2_sg_id" {
  name  = "/${var.project}/${var.environment}/ec2_sg_id"
  type  = "String"
  value = module.ec2_sg.sg_id
}

resource "aws_ssm_parameter" "rds_sg_id" {
  name  = "/${var.project}/${var.environment}/rds_sg_id"
  type  = "String"
  value = module.rds_sg.sg_id
}


resource "aws_ssm_parameter" "ingress_alb_sg_id" {
  name  = "/${var.project}/${var.environment}/ingress_alb_sg_id"
  type  = "String"
  value = module.ingress_alb_sg.sg_id
}

resource "aws_ssm_parameter" "eks_control_plane_sg_id" {
  name  = "/${var.project}/${var.environment}/eks_control_plane_sg_id"
  type  = "String"
  value = module.eks_control_plane_sg.sg_id
}

resource "aws_ssm_parameter" "eks_node_sg_id" {
  name  = "/${var.project}/${var.environment}/eks_node_sg_id"
  type  = "String"
  value = module.eks_node_sg.sg_id
}