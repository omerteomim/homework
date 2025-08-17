variable "replica_count" {
  description = "Number of nginx ingress controller replicas"
  type        = number
  default     = 2
}

variable "service_type" {
  description = "Kubernetes service type for ingress controller"
  type        = string
  default     = "LoadBalancer"
}

variable "environment" {
  description = "Environment name"
  type        = string
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