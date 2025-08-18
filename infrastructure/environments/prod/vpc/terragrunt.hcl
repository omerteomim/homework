include "env" {
  path = find_in_parent_folders("prod.hcl")
}

terraform {
  source = "../../../modules/vpc"
}