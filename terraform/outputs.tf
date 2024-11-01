output "ssm_instance_profile_name" {
  description = "The instance profile for SSM access"
  value       = aws_iam_instance_profile.ssm_instance_profile.name
}

