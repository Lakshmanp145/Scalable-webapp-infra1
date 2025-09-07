resource "aws_ssm_parameter" "app_alb_listener_arn" {
  name  = "/${var.project}/${var.environment}/app_alb_listener_arn"
  type  = "String"
  value = aws_lb_listener.https.arn
}

resource "aws_ssm_parameter" "app_alb_listener_arn_http" {
  name  = "/${var.project}/${var.environment}/app_alb_listener_arn_http"
  type  = "String"
  value = aws_lb_listener.http.arn
}