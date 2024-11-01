#resource "null_resource" "remove_argocd" {
#  provisioner "local-exec" {
#    when    = destroy
#    command = "helm uninstall argo-cd -n argocd && kubectl delete namespace argocd"
#  }

#  depends_on = [
#    helm_release.argo_cd,
#    kubernetes_namespace.argocd
#  ]
#}

resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.cluster_version
  vpc_config {
    subnet_ids = aws_subnet.private_subnet[*].id
  }

  tags = {
    Name = var.cluster_name
    Project = var.project_tag
  }
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = aws_subnet.private_subnet[*].id

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_size
    min_size     = var.min_size
  }

  instance_types = [var.instance_type]

  tags = {
    Name    = "${var.cluster_name}-node-group"
    Project = var.project_tag
  }
}

data "aws_eks_cluster" "eks_cluster" {
  name = aws_eks_cluster.eks_cluster.name
}

data "aws_eks_cluster_auth" "eks_auth" {
  name = aws_eks_cluster.eks_cluster.name
}

# OIDC provider for EKS Cluster
resource "aws_iam_openid_connect_provider" "oidc_provider" {
  url            = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer  # Referencing the resource directly
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b2f5bb57e641ab8b6"]  # AWS root CA thumbprint
}
