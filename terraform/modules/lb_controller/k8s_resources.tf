resource "kubernetes_service_account" "alb_sa" {
  metadata {
    name      = "alb-controller-sa"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_controller_role.arn
    }
  }
}

resource "kubernetes_cluster_role" "alb_controller_role" {
  metadata {
    name = "alb-controller-cluster-role"
  }

  rule {
    api_groups = [""]
    resources  = ["services", "endpoints", "configmaps", "pods", "events"]
    verbs      = ["get", "list", "watch", "create", "update", "delete", "patch"]
  }

  rule {
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
    verbs      = ["get", "list", "watch", "create", "update"]
  }

  rule {
    api_groups = ["elbv2.k8s.aws"]
    resources  = [
      "targetgroupbindings",
      "ingressclassparams",  # Added permission for IngressClassParams
      "ingressclassparams/status"
    ]
    verbs      = ["get", "list", "watch", "create", "update", "delete", "patch"]
  }

  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses", "ingressclasses", "ingresses/status"]
    verbs      = ["get", "list", "watch", "create", "update", "delete", "patch"]
  }

  rule {
    api_groups = ["elbv2.k8s.aws"]
    resources  = ["targetgroupbindings/finalizers", "ingressclassparams/finalizers"]
    verbs      = ["update"]
  }
}

resource "kubernetes_cluster_role_binding" "alb_controller_role_binding" {
  metadata {
    name = "alb-controller-cluster-role-binding"
  }

  role_ref {
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.alb_controller_role.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.alb_sa.metadata[0].name
    namespace = "kube-system"
  }
}
