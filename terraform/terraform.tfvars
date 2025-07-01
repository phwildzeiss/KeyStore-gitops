cluster_name           = "test-cluster"
namespace_name_ingress = "ingress"

tenants = {
  tenant-a = {
    namespace_name = "tenant-a"
    db_name        = "tenant-a-db"
    secret_name    = "tenant-a-db-secret"
    exoscale_zone  = "at-vie-2"
  }
}