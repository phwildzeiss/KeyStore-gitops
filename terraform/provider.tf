terraform {
  required_providers {
    exoscale = {
      source  = "exoscale/exoscale"
      version = "0.64.1"
    }
  }
}

provider "exoscale" {
  key    = var.exoscale_key
  secret = var.exoscale_secret
}

provider "helm" {
  kubernetes = {
    config_path = "kubeconfig"
  }
}
