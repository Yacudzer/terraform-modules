resource "random_pet" "random_name" {
  length    = 2
  separator = "-"
}

resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "this" {
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  name             = var.name
  namespace        = var.namespace
  create_namespace = false
  version          = var.chart_version
  values           = var.yaml_values
  set {
    name  = "controller.service.enabled"
    value = "false"
  }
  depends_on = [
    kubernetes_namespace.this
  ]
}

resource "google_compute_address" "static_ip" {
  for_each = toset(local.current_state)
  region   = var.google_region
  name = "lb-${var.name}-${random_pet.rotated_resources[each.key].id}"
  address_type = var.address_type
  subnetwork   = var.address_type == "INTERNAL" ? var.subnetwork_id : null
}

#resource "kubernetes_service" "ingress_lb" {
#  for_each  = local.rotation_enabled ? toset(local.current_state) : []
#  wait_for_load_balancer = true
#  metadata {
#    name      =
#    namespace = kubernetes_namespace.ingress.metadata.0.name
#    annotations = {
#      "cloud.google.com/neg" = jsonencode(
#        {
#          ingress = true
#        }
#      )
#    }
#  }
#  spec {
#    type             = "LoadBalancer"
#    load_balancer_ip = google_compute_address.lb_external_ip.address
#    ip_families      = ["IPv4"]
#    selector = {
#      qwerty = "aaa"
#      asdfgh = "bbb"
#    }
#    port {
#      name        = "http"
#      port        = 80
#      target_port = 80
#    }
#    port {
#      name        = "https"
#      port        = 443
#      target_port = 443
#    }
#  }
#  depends_on = [
#    kubernetes_namespace.ingress
#  ]
#}