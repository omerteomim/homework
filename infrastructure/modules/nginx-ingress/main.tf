resource "kubernetes_namespace" "ingress-nginx" {
  metadata {
    name = "ingress-nginx-${var.environment}"
    labels = {
      name = "ingress-nginx-${var.environment}"
    }
  }
}

resource "helm_release" "nginx_ingress" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = kubernetes_namespace.ingress-nginx.metadata[0].name
  version          = "4.8.3"

  set = concat(
    [
      {
        name  = "controller.replicaCount"
        value = var.replica_count
      },
      {
        name  = "controller.service.type"
        value = var.service_type
      },
      {
        name  = "controller.metrics.enabled"
        value = "true"
      },
      {
        name  = "controller.podSecurityContext.runAsUser"
        value = "101"
      }
    ],
    var.service_type == "LoadBalancer" ? [
      {
        name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
        value = "nlb"
      },
      {
        name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-cross-zone-load-balancing-enabled"
        value = "true"
      }
    ] : []
  )
}