terraform {
  backend "s3" {
    endpoint                    = "https://sos-at-vie-1.exo.io" # je nach Region z. B. sos-ch-dk-2.exo.io
    bucket                      = "my-terraform-state"
    key                         = "infra/terraform.tfstate"
    region                      = "us-east-1"
    force_path_style            = true # nötig für Ceph‑S3‑Kompatibilität
    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}
