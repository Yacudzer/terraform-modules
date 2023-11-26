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

data "google_dns_managed_zone" "dns_zone" {
  count = var.dns != null ? 1 : 0
  name  = var.dns.zone_name
}

resource "google_dns_record_set" "dns_record" {
  count        = var.dns != null ? 1 : 0
  managed_zone = data.google_dns_managed_zone.dns_zone.0.name
  name         = "${var.dns.hostname}.${data.google_dns_managed_zone.dns_zone.0.dns_name}"
  type         = "A"
  ttl          = var.dns.ttl
  rrdatas = [
    google_compute_address.static_ip[local.last_element_from_current_state].address
  ]
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
