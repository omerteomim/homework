variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "app_repo_url" {
  description = "Repository URL for the application"
  type        = string
}

variable "app_git_branch" {
  description = "Branch for the application"
  type        = string
}

variable "app_path" {
  description = "Path to the application"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "cluster_ca" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "Endpoint for EKS cluster"
  type        = string
}