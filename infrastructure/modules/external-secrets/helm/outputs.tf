output "namespace" {
  value = kubernetes_namespace.eso.metadata[0].name
}