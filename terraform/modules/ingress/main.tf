terraform {
  required_providers {
    exoscale = {
      source = "exoscale/exoscale"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

# Kubernetes Namespace für den Mandanten
resource "kubernetes_namespace" "ingress_ns" {
  metadata {
    name = var.namespace_name_ingress
  }
}

resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = var.namespace_name_ingress
}
