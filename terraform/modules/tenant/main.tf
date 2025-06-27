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
resource "kubernetes_namespace" "tenant_ns" {
  metadata {
    name = var.namespace_name
  }
}

# Exoscale PostgreSQL Datenbank für den Mandanten
resource "exoscale_database" "tenant_db" {
  name                   = var.db_name
  type                   = "pg"
  zone                   = var.exoscale_zone
  plan                   = var.db_plan
  termination_protection = false

  pg {
    version         = var.db_version
    backup_schedule = var.db_backup_schedule
    ip_filter       = var.db_ip_filter
    pg_settings     = jsonencode(var.db_pg_settings)
  }
}

# Datenbank URI abrufen (für Credentials etc)
data "exoscale_database_uri" "tenant_db_uri" {
  name = exoscale_database.tenant_db.name
  type = "pg"
  zone = var.exoscale_zone

  depends_on = [exoscale_database.tenant_db]
}

# Kubernetes Secret mit DB-Zugangsdaten
resource "kubernetes_secret" "db_secret" {
  metadata {
    name      = var.secret_name
    namespace = kubernetes_namespace.tenant_ns.metadata[0].name
  }

  data = {
    DB_USERNAME = data.exoscale_database_uri.tenant_db_uri.username
    DB_PASSWORD = data.exoscale_database_uri.tenant_db_uri.password
    DB_URL      = "jdbc:postgresql://${data.exoscale_database_uri.tenant_db_uri.host}:${data.exoscale_database_uri.tenant_db_uri.port}/defaultdb"
  }

  type = "Opaque"

  depends_on = [kubernetes_namespace.tenant_ns]
}
