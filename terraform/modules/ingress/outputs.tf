output "namespace_name_ingress" {
  description = "Namespace des Ingress"
  value       = kubernetes_namespace.ingress_ns.metadata[0].name
}
