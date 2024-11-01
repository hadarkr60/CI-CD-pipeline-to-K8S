output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.name
}

output "cluster_endpoint" {
  description = "The API server endpoint of the EKS cluster"
  value       = data.aws_eks_cluster.eks_cluster.endpoint
}

output "node_group_arn" {
  description = "The ARN of the EKS node group"
  value       = aws_eks_node_group.eks_node_group.arn
}

output "eks_vpc_id" {
  description = "The ID of the VPC created for the EKS cluster"
  value       = aws_vpc.eks_vpc.id
}

output "cluster_ca" {
  description = "The certificate authority for the EKS cluster"
  value       = data.aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "auth_token" {
  description = "Authentication token for accessing the EKS cluster"
  value       = data.aws_eks_cluster_auth.eks_auth.token
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.oidc_provider.arn
}

output "oidc_issuer_url" {
  value = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}


