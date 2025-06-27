cluster_name           = "test-cluster"
namespace_name_ingress = "ingress"

tenants = {
  tenant-b = {
    namespace_name = "tenant-b"
    db_name        = "tenant-b-db"
    secret_name    = "tenant-b-db-secret"
    exoscale_zone  = "at-vie-2"
  }
}