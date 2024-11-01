variable "project_tag" {
  description = "project tag"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the EKS VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs for the EKS cluster"
  type        = list(string)
  
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs for the EKS cluster"
  type        = list(string)
}

variable "availability_zones" {
  description = "The availability zones for the EKS subnets"
  type        = list(string)
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type for the worker nodes"
  type        = string
  default     = "t2.medium"
}

variable "desired_capacity" {
  description = "The desired number of worker nodes"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "The maximum number of worker nodes"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "The minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_role_policies" {
  description = "List of policies to attach to the worker node IAM role."
  type        = list(string)
  default     = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
  ]
}

variable "cluster_version" {
  description = " k8s version for eks"
  type        = string
}
