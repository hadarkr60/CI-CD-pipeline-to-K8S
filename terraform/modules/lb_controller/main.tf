resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version = var.helm_version

  namespace  = "kube-system"

  depends_on = [
  kubernetes_service_account.alb_sa,
  ]
  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = "false"  # We are creating the service account ourselves
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.alb_sa.metadata[0].name
  }
  
  set {
    name  = "podLabels.app\\.kubernetes\\.io/component"
    value = "controller"
  }
}

resource "kubernetes_deployment" "python_hello_api" {
  metadata {
    name = "python-hello-api"
    labels = {
      app = "python-hello-api"
    }
  }

  spec {
    replicas = 2  # Number of replicas

    selector {
      match_labels = {
        app = "python-hello-api"
      }
    }

    template {
      metadata {
        labels = {
          app = "python-hello-api"
        }
      }

      spec {
        container {
          name  = "python-hello-api"
          image = "hadarkravetsky/python_hello_api:2"

          port {
            container_port = 3000  # Expose the container on port 3000
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }

            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }
        }
      }
    }
  }
}

# Kubernetes Service
resource "kubernetes_service" "my_app_service" {
  metadata {
    name = "pyrhon-hello-api-service"
    labels = {
      app = "python-hello-api"
    }
  }
  spec {
    selector = {
      app = "python-hello-api"
    }
    port {
      port        = 80
      target_port = 3000
    }
    type = "ClusterIP"
  }
}


#kubernetes ingress
resource "kubernetes_ingress_v1" "my_app_ingress" {
  metadata {
    name = "my-app-ingress"
    annotations = {
      "kubernetes.io/ingress.class"                = "alb"
      "alb.ingress.kubernetes.io/scheme"           = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"      = "ip"
      "alb.ingress.kubernetes.io/listen-ports"     = "[{\"HTTP\": 80}]"
      "alb.ingress.kubernetes.io/healthcheck-path" = "/health"
      "alb.ingress.kubernetes.io/success-codes"    = "200"
    }
  }

  spec {
    rule {
      http {
        path {
          path = "/"
          path_type = "Prefix"  # Required for networking.k8s.io/v1
          backend {
            service {
              name = kubernetes_service.my_app_service.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
