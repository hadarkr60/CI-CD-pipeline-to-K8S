variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "project_tag" {
  description = "Project tag"
  type        = string
  default     = "k8s-jenkins-docker"
}

variable "cluster_name" {
  description = "your cluster name"
  type        = string
  default     = "eks-cluster"
}

variable "az" {
  description = "AZ for instances under ALB"
  type        = string
  default     = "us-east-1a"
} 
