include "env" {
  path = find_in_parent_folders("prod.hcl")
}

terraform {
  source = "../../../modules/nginx-ingress"
}

dependency "eks" {
  config_path = "../eks"
}

inputs = {
  replica_count  = 3
  service_type   = "LoadBalancer"
  cluster_name     = dependency.eks.outputs.cluster_name
  cluster_endpoint = dependency.eks.outputs.cluster_endpoint
  cluster_ca       = dependency.eks.outputs.cluster_ca_certificate
}