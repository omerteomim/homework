include "env" {
  path = find_in_parent_folders("dev.hcl")
}

terraform {
  source = "../../../modules/vpc"
}

