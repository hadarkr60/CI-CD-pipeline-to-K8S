variable "project_tag" {
  description = "project tag"
  type        = string
}
variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "gitlab_private_ip" {
  description = "The private IP address of the GitLab instance"
  type        = string
}

variable "jenkins_private_ip" {
  description = "The private IP address of the Jenkins instance"
  type        = string
}


variable "jenkins_listener_condition" {
  description = "Optional listener condition to route Jenkins"
  type        = string
  default     = "/jenkins*"
}
