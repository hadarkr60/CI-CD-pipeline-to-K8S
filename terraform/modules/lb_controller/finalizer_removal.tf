resource "null_resource" "remove_ingress_finalizer" {
  provisioner "local-exec" {
    when    = destroy
    command = "kubectl patch ingress my-app-ingress -n default -p '{\"metadata\":{\"finalizers\":null}}'"
  }

  depends_on = [
    helm_release.aws_load_balancer_controller
  ]
}

