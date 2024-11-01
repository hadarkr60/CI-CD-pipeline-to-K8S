variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the development VPC"
  default     = "172.32.0.0/16"
}

variable "public_subnet_cidr_1" {
  type        = string
  description = "CIDR block for the first public subnet"
  default     = "172.32.1.0/24"
}

variable "public_subnet_cidr_2" {
  type        = string
  description = "CIDR block for the second public subnet"
  default     = "172.32.3.0/24"
}

variable "private_subnet_cidr" {
  type        = string
  description = "CIDR block for the private subnet"
  default     = "172.32.2.0/24"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "project_tag" {
  type        = string
  description = "Project tag"
}

variable "instaces_availability_zone" {
  description = "AZ for host dedicated instances"
  type        = string
}
