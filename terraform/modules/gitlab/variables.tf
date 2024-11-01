variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "instances_availability_zone" {
  description = "Availability zone for instances which has to be one of the ALB's AZs"
  type         = string
}

variable "alb_security_group" {
  description = "ALB development vpc"
  type        = string
}

variable "private_subnet_id" {
  description = "The ID of the private subnet where GitLab will be deployed"
  type        = string
}

variable "private_subnet_cidr" {
  description = "The CIDR block of the private subnet"
  type        = string
}

# AMI and Instance Type for GitLab
variable "ami_id" {
  description = "The AMI ID for the EC2 instance running GitLab"
  type        = string
  default     = "ami-0d3b07ade78eb3ec2"
}

variable "instance_type" {
  description = "The instance type for the EC2 instance running GitLab"
  type        = string
  default     = "t2.medium"
}

# IAM Instance Profile for SSM access
variable "iam_instance_profile" {
  description = "The IAM instance profile for enabling SSM access"
  type        = string
}

variable "project_tag" {
  description = "project tag"
  type        = string
}

variable "private-ip" {
  description = "private ip for gitlab"
  type        = string
  default     = "172.32.2.11"
}
