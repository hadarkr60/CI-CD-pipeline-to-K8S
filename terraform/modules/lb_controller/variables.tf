variable "oidc_issuer_url" {
  type        = string
  description = "OIDC Issuer URL for the Load Balancer Controller"
}

variable "oidc_provider_arn" {
  type        = string
  description = "OIDC provider arn"
}

variable "region" {
  description = "The AWS region."
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "helm_version" {
  description = "version for the load balancer helm chart"
  type        = string
  default     = "1.8.3"
}

variable "project_tag" {
  description = "Project tag for resource tagging"
  type        = string
}
