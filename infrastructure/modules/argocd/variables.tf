variable "chart_version" {
  description = "Helm chart version"
  type        = string
  default     = "5.51.6"
}

variable "admin_pass" {
  description = "Admin password for ArgoCD"
  type        = string
  default     = "password"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "Endpoint for EKS cluster"
  type        = string
}

variable "cluster_ca" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  type        = string
}

variable "namespace" {
  description = "Namespace to install ArgoCD"
  type        = string
  default     = "argocd"
}

variable "release_name" {
  description = "Helm release name"
  type        = string
  default     = "argocd"
}

