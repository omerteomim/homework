resource "kubernetes_namespace" "eso" {
  metadata {
    name = "external-secrets"
  }
}

data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name 
}

resource "aws_iam_role" "eso_role" {
  name = "external-secrets-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")}"
        }
        Condition = {
          StringEquals = {
            "${replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:external-secrets:external-secrets"
            "${replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

data "aws_iam_policy_document" "eso" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]
    resources = ["arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:${var.environment}/myapp/*"]
  }
}

resource "aws_iam_role_policy" "eso_policy" {
  name   = "external-secrets-policy"
  role   = aws_iam_role.eso_role.id
  policy = data.aws_iam_policy_document.eso.json
}

resource "helm_release" "eso" {
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  version    = "0.10.6"
  namespace  = "external-secrets"

  depends_on = [kubernetes_namespace.eso]

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.eso_role.arn
  }
}

resource "kubernetes_manifest" "aws_secret_store" {
  depends_on = [helm_release.eso]
  
  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ClusterSecretStore"
    metadata = {
      name      = "aws-secrets"
      namespace = "default"
    }
    spec = {
      provider = {
        aws = {
          service = "SecretsManager"
          region  = var.region
          auth = {
            jwt = {
              serviceAccountRef = {
                name      = "external-secrets"
                namespace = "external-secrets"
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
      namespace = "default"
    }
    spec = {
      refreshInterval = "1m"
      secretStoreRef = {
        name = "aws-secrets"
        kind = "SecretStore"
      }
      target = {
        name = "app-secrets"
      }
      data = [
        {
          secretKey = "api_key"
          remoteRef = {
            key = "${var.environment}/myapp/api_key"
          }
        }
      ]
    }
  }
}