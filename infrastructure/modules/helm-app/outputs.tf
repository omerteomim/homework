output "environment" {
  description = "Current environment"
  value       = var.environment
}

output "dev_namespace" {
  description = "Dev namespace name"
  value       = var.environment == "dev" ? kubernetes_namespace.dev[0].metadata[0].name : null
}

output "prod_namespace" {
  description = "Production namespace name"
  value       = var.environment == "prod" ? kubernetes_namespace.prod[0].metadata[0].name : null
}