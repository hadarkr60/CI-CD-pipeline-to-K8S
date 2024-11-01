#manipulation of oidc provider for the trust policy
locals {
  oidc_provider_id = regex("id/([^/]+)$", var.oidc_issuer_url)[0]
}


resource "aws_iam_role" "alb_controller_role" {
  name = "alb-controller-role-${var.cluster_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = var.oidc_provider_arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          "StringEquals" = {
            "oidc.eks.${var.region}.amazonaws.com/id/${local.oidc_provider_id}:sub" = "system:serviceaccount:kube-system:alb-controller-sa"
          }
        }
      }
    ]
  })


  tags = {
    Name    = "alb-controller-role"
    Project = var.project_tag
  }
}



resource "aws_iam_policy" "alb_policy" {
  name   = "AWSLoadBalancerControllerIAMPolicy-${var.cluster_name}"
  policy = file("${path.module}/iam_policy.json")
}

resource "aws_iam_role_policy_attachment" "alb_controller_policy_attach" {
  role       = aws_iam_role.alb_controller_role.name
  policy_arn = aws_iam_policy.alb_policy.arn
}
