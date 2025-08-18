include "env" {
  path = find_in_parent_folders("dev.hcl")
}

terraform {
  source = "../../../../modules/external-secrets/manifests"
}

dependency "eks" {
  config_path = "../../eks"
}

dependency "helm" {
  config_path = "../helm"
}

inputs = {
  cluster_name     = dependency.eks.outputs.cluster_name
  cluster_endpoint = dependency.eks.outputs.cluster_endpoint
  cluster_ca       = dependency.eks.outputs.cluster_ca_certificate
  namespace        = dependency.helm.outputs.namespace
}