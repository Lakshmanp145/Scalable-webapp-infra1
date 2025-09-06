resource "aws_ssm_parameter" "aws_alb_certificate_arn" {
  name  = "/${var.project_name}/${var.environment}/aws_alb_certificate_arn"
  type  = "String"
  value = aws_acm_certificate.expense.arn
}