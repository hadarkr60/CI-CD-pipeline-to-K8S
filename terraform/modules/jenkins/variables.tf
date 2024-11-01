variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "instances_availability_zone" {
  description = "Availability zone for instances which has to be one of the ALB's AZs"
  type         = string
}


variable "private_subnet_id" {
  description = "The ID of the private subnet where Jenkins will be deployed"
  type        = string
}

variable "private_subnet_cidr" {
  description = "The CIDR block of the private subnet"
  type        = string
}

variable "alb_security_group" {
  description = "ALB development vpc security group"
  type        = string
}
variable "ami_id" {
  description = "The AMI ID for the EC2 instance running Jenkins"
  type        = string
  default     = "ami-0023b8dcd3cbf52da"
}

variable "instance_type" {
  description = "The instance type for the EC2 instance running Jenkins"
  type        = string
  default     = "t2.medium"
}

variable "iam_instance_profile" {
  description = "The IAM instance profile for enabling SSM access"
  type        = string
}

variable "jenkins_private_ip" {
  description = "private ip for jenkins master"
  type        = string
  default     = "172.32.2.10"  #as it configured within my default AMI
}

variable "jenkins_private_ip_cidr" {
  description = "for ingress syntax in security group definition"
  type        = string
  default     = "172.32.2.10/32"  #as it configured within my default AMI
}


variable "project_tag" {
  description = "project tag"
  type        = string
}

variable "agent_ami_id" {
  description = "AMI for agent"
  type        = string
  default     = "ami-047455fb489b3173a"
}

variable "jenkins_agent_private_ip" {
  description = "Jenkins agent private ip"
  default    = "172.32.2.12"
}
