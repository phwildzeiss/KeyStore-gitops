provider "kubernetes" {
  alias       = "cluster"
  config_path = local_sensitive_file.kubeconfig.filename
}

resource "exoscale_sks_cluster" "my_sks_cluster" {
  zone          = var.exoscale_zone
  name          = var.cluster_name
  service_level = var.sks_service_level
}

resource "exoscale_sks_nodepool" "my_sks_nodepool" {
  cluster_id = exoscale_sks_cluster.my_sks_cluster.id
  zone       = exoscale_sks_cluster.my_sks_cluster.zone
  name       = "${var.cluster_name}-nodepool"

  instance_type = "standard.medium"
  size          = 3
  security_group_ids = [
  exoscale_security_group.my_sks_security_group.id]
}

resource "exoscale_sks_kubeconfig" "my_sks_kubeconfig" {
  cluster_id = exoscale_sks_cluster.my_sks_cluster.id
  zone       = exoscale_sks_cluster.my_sks_cluster.zone

  user   = "kubernetes-admin"
  groups = ["system:masters"]
}

resource "local_sensitive_file" "kubeconfig" {
  content         = exoscale_sks_kubeconfig.my_sks_kubeconfig.kubeconfig
  filename        = "kubeconfig"
  file_permission = "0600"
}

# (ad-hoc security group)
resource "exoscale_security_group" "my_sks_security_group" {
  name = "my-sks-security-group"
}

resource "exoscale_security_group_rule" "kubelet" {
  security_group_id = exoscale_security_group.my_sks_security_group.id
  description       = "Kubelet"
  type              = "INGRESS"
  protocol          = "TCP"
  start_port        = 10250
  end_port          = 10250
  # (beetwen worker nodes only)
  user_security_group_id = exoscale_security_group.my_sks_security_group.id
}

resource "exoscale_security_group_rule" "calico_vxlan" {
  security_group_id = exoscale_security_group.my_sks_security_group.id
  description       = "VXLAN (Calico)"
  type              = "INGRESS"
  protocol          = "UDP"
  start_port        = 4789
  end_port          = 4789
  # (beetwen worker nodes only)
  user_security_group_id = exoscale_security_group.my_sks_security_group.id
}

resource "exoscale_security_group_rule" "nodeport_tcp" {
  security_group_id = exoscale_security_group.my_sks_security_group.id
  description       = "Nodeport TCP services"
  type              = "INGRESS"
  protocol          = "TCP"
  start_port        = 30000
  end_port          = 32767
  # (public)
  cidr = "0.0.0.0/0"
}

resource "exoscale_security_group_rule" "nodeport_udp" {
  security_group_id = exoscale_security_group.my_sks_security_group.id
  description       = "Nodeport UDP services"
  type              = "INGRESS"
  protocol          = "UDP"
  start_port        = 30000
  end_port          = 32767
  # (public)
  cidr = "0.0.0.0/0"
}

resource "null_resource" "wait_for_kubeconfig" {
  depends_on = [local_sensitive_file.kubeconfig]
}

resource "exoscale_security_group_rule" "http" {
  security_group_id = exoscale_security_group.my_sks_security_group.id
  description       = "Allow HTTP"
  type              = "INGRESS"
  protocol          = "TCP"
  start_port        = 80
  end_port          = 80
  cidr              = "0.0.0.0/0"
}

resource "exoscale_security_group_rule" "https" {
  security_group_id = exoscale_security_group.my_sks_security_group.id
  description       = "Allow HTTPS"
  type              = "INGRESS"
  protocol          = "TCP"
  start_port        = 443
  end_port          = 443
  cidr              = "0.0.0.0/0"
}

# Jetzt deine Tenants als Module einbinden

module "tenants" {
  for_each = var.tenants
  source   = "./modules/tenant"

  namespace_name = each.value.namespace_name
  db_name        = each.value.db_name
  secret_name    = each.value.secret_name
  exoscale_zone  = each.value.exoscale_zone

  providers = {
    exoscale   = exoscale
    kubernetes = kubernetes.cluster
  }

  depends_on = [null_resource.wait_for_kubeconfig]
}

module "ingress" {
  source                 = "./modules/ingress"
  namespace_name_ingress = var.namespace_name_ingress
  providers = {
    exoscale   = exoscale
    kubernetes = kubernetes.cluster
  }

  depends_on = [null_resource.wait_for_kubeconfig]
}
