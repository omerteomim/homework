resource "kubernetes_namespace" "dev" {
  count = var.environment == "dev" ? 1 : 0
  
  metadata {
    name = "dev"
    labels = {
      name = "dev"
    }
  }
}

resource "kubernetes_namespace" "prod" {
  count = var.environment == "prod" ? 1 : 0
  
  metadata {
    name = "prod"
    labels = {
      name = "prod"
    }
  }
}

resource "kubernetes_manifest" "helm_dev_app" {
  count = var.environment == "dev" ? 1 : 0
  
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "helm-dev-app"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.app_repo_url
        targetRevision = var.app_git_branch
        path          = var.app_path
      }
      values = yamlencode({
            image = {
              repository = "omerteomim/dev-app"
              tag        = "latest"
            }
      })
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "dev"
      }
      syncPolicy = {
        automated = {
          prune      = true
          selfHeal   = true
          allowEmpty = true
        }
        syncOptions = ["CreateNamespace=true"]
      }
    }
  }
}

resource "kubernetes_manifest" "helm_staging_app" {
  count = var.environment == "dev" ? 1 : 0
  
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "helm-staging-app"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.app_repo_url
        targetRevision = var.app_git_branch
        path          = var.app_path
      }
      values = yamlencode({
            image = {
              repository = "omerteomim/staging-app"
              tag        = "latest"
            }
      })
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "dev"
      }
      syncPolicy = {
        automated = {
          prune      = true
          selfHeal   = true
          allowEmpty = true
        }
        syncOptions = ["CreateNamespace=true"]
      }
    }
  }
}

resource "kubernetes_manifest" "helm_prod_app" {
  count = var.environment == "prod" ? 1 : 0
  
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "helm-prod-app"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.app_repo_url
        targetRevision = var.app_git_branch
        path          = var.app_path
      }
      values = yamlencode({
            image = {
              repository = "omerteomim/prod-app"
              tag        = "latest"
            }
      })
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "prod"
      }
      syncPolicy = {
        automated = {
          prune      = true
          selfHeal   = true
          allowEmpty = true
        }
        syncOptions = ["CreateNamespace=true"]
      }
    }
  }
}


