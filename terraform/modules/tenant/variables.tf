variable "namespace_name" {
  description = "Kubernetes Namespace für den Mandanten"
  type        = string
}

variable "db_name" {
  description = "Datenbankname für den Mandanten"
  type        = string
}

variable "db_plan" {
  description = "Exoscale Datenbank Plan"
  type        = string
  default     = "hobbyist-2"
}

variable "db_version" {
  description = "PostgreSQL Version"
  type        = string
  default     = "15"
}

variable "db_backup_schedule" {
  description = "Backup-Zeitpunkt"
  type        = string
  default     = "04:00"
}

variable "db_ip_filter" {
  description = "IP Filter Liste für DB"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Bitte später anpassen!
}

variable "db_pg_settings" {
  description = "PostgreSQL Einstellungen"
  type        = map(string)
  default = {
    timezone = "Europe/Zurich"
  }
}

variable "secret_name" {
  description = "Name des Kubernetes Secrets mit DB Credentials"
  type        = string
  default     = "db-secret"
}

variable "exoscale_zone" {
  description = "Exoscale Zone"
  type        = string
}
