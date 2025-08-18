include "env" {
  path = find_in_parent_folders("prod.hcl")
}

terraform {
  source = "../../../../modules/external-secrets/helm"
}

dependency "eks" {
  config_path = "../../eks"
}

dependency "app" {
    config_path = "../../applications/helm-dev-app"
}

inputs = {
  namespace        = dependency.app.outputs.prod_namespace
  cluster_name     = dependency.eks.outputs.cluster_name
  cluster_endpoint = dependency.eks.outputs.cluster_endpoint
  cluster_ca       = dependency.eks.outputs.cluster_ca_certificate
}