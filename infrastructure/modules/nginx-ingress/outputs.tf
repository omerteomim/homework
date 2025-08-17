output "namespace" {
  description = "Namespace where nginx ingress is deployed"
  value       = helm_release.nginx_ingress.namespace
}

output "name" {
  description = "Name of the nginx ingress release"
  value       = helm_release.nginx_ingress.name
}

output "service_name" {
  description = "Name of the nginx ingress controller service"
  value       = "ingress-nginx-controller-${var.environment}"
}