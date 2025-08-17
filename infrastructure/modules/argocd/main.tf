resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.namespace
    labels = {
      name = var.namespace
    }
  }
}

resource "bcrypt_hash" "argocd_admin_password" {
  cleartext = var.admin_pass
  cost      = 10
}

resource "helm_release" "argocd" {
  name       = var.release_name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  
  values = [
    yamlencode({
        server = {
            service = {
                type = "LoadBalancer"
                annotations = {
                    "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
                    "service.beta.kubernetes.io/aws-load-balancer-scheme" = "internet-facing"
                }
            }
            ingress = {
                enabled = false
            }
        }
        configs = {
            secret = {
                argocdServerAdminPassword = bcrypt_hash.argocd_admin_password.id
                argocdServerAdminPasswordMtime = "2024-01-01T00:00:00Z"
            }
        }
    })
  ]

  depends_on = [kubernetes_namespace.argocd]
}