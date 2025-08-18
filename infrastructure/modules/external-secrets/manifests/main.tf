resource "kubernetes_manifest" "aws_secret_store" {
  
  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ClusterSecretStore"
    metadata = {
      name      = "aws-secrets"
    }
    spec = {
      provider = {
        aws = {
          service = "SecretsManager"
          region  = var.aws_region
          auth = {
            jwt = {
              serviceAccountRef = {
                name      = "external-secrets"
                namespace = "dev"
              }
            }
          }
        }
      }
    }
  }
}

# Create External Secret to sync from AWS
resource "kubernetes_manifest" "app_secrets" {
  depends_on = [kubernetes_manifest.aws_secret_store]
  
  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ExternalSecret"
    metadata = {
      name      = "app-secrets"
      namespace = "dev"
    }
    spec = {
      refreshInterval = "1m"
      secretStoreRef = {
        name = "aws-secrets"
        kind = "ClusterSecretStore"
      }
      target = {
        name = "app-secrets"
      }
      data = [
        {
          secretKey = "OPENROUTER_API_KEY"
          remoteRef = {
            key = "${var.environment}/myapp/api_key"
          }
        }
      ]
    }
  }
}