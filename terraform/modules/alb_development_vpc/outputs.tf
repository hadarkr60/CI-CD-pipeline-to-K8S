output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.dev_alb.dns_name
}

output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}
