include "env" {
  path = find_in_parent_folders("dev.hcl")
}

terraform {
  source = "../../../modules/external-secrets"
}

dependency "eks" {
  config_path = "../eks"
}

inputs = {
  region       = local.aws_region
  cluster_name     = dependency.eks.outputs.cluster_name
}