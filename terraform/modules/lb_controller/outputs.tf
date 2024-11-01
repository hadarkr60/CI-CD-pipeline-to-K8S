output "alb_controller_role_arn" {
  description = "IAM Role ARN for the ALB controller"
  value       = aws_iam_role.alb_controller_role.arn
}

output "app_service_url" {
  description = "URL for accessing the application via the ALB"
  value       = kubernetes_ingress.app_ingress.status[0].load_balancer.ingress[0].hostname
}
