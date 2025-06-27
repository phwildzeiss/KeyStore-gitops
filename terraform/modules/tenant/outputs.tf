output "namespace_name" {
  description = "Namespace des Mandanten"
  value       = kubernetes_namespace.tenant_ns.metadata[0].name
}

output "db_name" {
  description = "Name der PostgreSQL Datenbank"
  value       = exoscale_database.tenant_db.name
}

output "db_username" {
  description = "Datenbank Benutzername"
  value       = data.exoscale_database_uri.tenant_db_uri.username
  sensitive   = true
}

output "db_password" {
  description = "Datenbank Passwort"
  value       = data.exoscale_database_uri.tenant_db_uri.password
  sensitive   = true
}
