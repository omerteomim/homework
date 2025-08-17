terraform {
  source = "../../../modules/argocd"
}

include "env" {
  path = find_in_parent_folders("dev.hcl")
}

dependency "eks" {
  config_path = "../eks"
}

inputs = {
  cluster_name     = dependency.eks.outputs.cluster_name
  cluster_endpoint = dependency.eks.outputs.cluster_endpoint
  cluster_ca       = dependency.eks.outputs.cluster_ca_certificate
  namespace        = "argocd"
  release_name     = "argocd"
}