include "env" {
  path = find_in_parent_folders("prod.hcl")
}

terraform {
  source = "../../../modules/eks"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  node_desired_size = 2
  node_min_size     = 1
  node_max_size     = 4
  node_instance_types = ["t3.large"]
  vpc_id = dependency.vpc.outputs.vpc_id
  private_subnets = dependency.vpc.outputs.private_subnets
  public_subnets = dependency.vpc.outputs.public_subnets
}