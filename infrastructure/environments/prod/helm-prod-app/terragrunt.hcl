include "env" {
  path = find_in_parent_folders("prod.hcl")
}

dependency "eks" {
  config_path = "../eks"
}

terraform {
  source = "../../../modules/helm-app"
}

inputs = {
  cluster_ca = dependency.eks.outputs.cluster_ca_certificate
  cluster_endpoint = dependency.eks.outputs.cluster_endpoint
  cluster_name = dependency.eks.outputs.cluster_name
  app_repo_url        = "https://github.com/omerteomim/homework-gitops.git"
  app_git_branch = "main"
  app_path           = "simple-chart"
}