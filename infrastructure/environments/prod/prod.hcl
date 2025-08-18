locals {
  environment = "prod"
  aws_region  = "us-east-1"
  common_tags = {
    Environment = "prod"
    Project     = "homework"
  }
}

remote_state {
  backend = "s3"
  config = {
    bucket  = "omer-state-tf"
    key     = "homework/${local.environment}/${path_relative_to_include()}/terraform.tfstate"
    region  = local.aws_region
  }
}

generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = ">= 1.4.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.33.0, <7.0.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.9.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.20.0"
    }
    bcrypt = {
      source  = "viktorradnai/bcrypt"
      version = ">= 0.1.2"
    }
  }
}
EOF
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "s3" {}
}
EOF
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
}
EOF
}

inputs = {
  environment = local.environment
  aws_region  = local.aws_region
  common_tags = local.common_tags
}
