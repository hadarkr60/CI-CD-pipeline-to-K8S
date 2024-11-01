output "gitlab_instance_id" {
  description = "The ID of the GitLab EC2 instance"
  value       = aws_instance.gitlab.id
}

output "gitlab_instance_private_ip" {
  description = "The private IP address of the GitLab EC2 instance"
  value       = aws_instance.gitlab.private_ip
}
