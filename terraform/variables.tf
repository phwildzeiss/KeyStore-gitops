variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
}

variable "exoscale_key" {
  type        = string
  description = "Exoscale API key"
}

variable "exoscale_secret" {
  type        = string
  description = "Exoscale API secret"
  sensitive   = false
}

variable "exoscale_zone" {
  type        = string
  description = "Exoscale zone to use"
  default     = "at-vie-2"
}

variable "sks_service_level" {
  type        = string
  description = "Service level for the SKS cluster"
  default     = "starter"
}

variable "tenants" {
  description = "Map of tenants"
  type = map(object({
    namespace_name = string
    db_name        = string
    secret_name    = string
    exoscale_zone  = string
  }))
}

variable "namespace_name_ingress" {
  type        = string
  description = "Name of nginx namespace"
}
