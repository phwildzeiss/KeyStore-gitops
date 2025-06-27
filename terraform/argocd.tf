resource "helm_release" "argo_cd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "8.0.0"
  timeout          = 1200
  create_namespace = true
  namespace        = "argocd"
  lint             = true
  wait             = true

  depends_on = [
    local_sensitive_file.kubeconfig
  ]
}

locals {
  repo_url      = "https://github.com/phwildzeiss/KeyStore-gitops.git"
  repo_path     = "argocd"
  app_name      = "gitops-base"
  app_namespace = "argocd"
}

resource "helm_release" "argo_cd_app" {
  name             = "argocd-apps"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-apps"
  version          = "1.4.1"
  timeout          = 1200
  create_namespace = true
  namespace        = "argocd"
  lint             = true
  wait             = true
  values = [templatefile("app-values.yaml", {
    repo_url      = local.repo_url
    repo_path     = local.repo_path
    app_name      = local.app_name
    app_namespace = local.app_namespace
  })]

  depends_on = [
    helm_release.argo_cd
  ]
}

resource "helm_release" "argo_cd_image_updater" {
  name             = "argocd-image-updater"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-image-updater"
  version          = "0.9.1" # (prüfe ggf. neueste Version)
  namespace        = "argocd"
  create_namespace = false
  wait             = true

  set = [
    {
      name  = "config.argocd.serverAddress"
      value = "argocd-server.argocd.svc"
    },
    {
      name  = "config.argocd.plaintext"
      value = "true"
    },
    {
      name  = "config.logLevel"
      value = "info"
    }
  ]

  depends_on = [helm_release.argo_cd]
}