# Query small instance size
data "civo_size" "small" {
  filter {
    key    = "type"
    values = ["kubernetes"]
  }

  sort {
    key       = "ram"
    direction = "asc"
  }
}

resource "civo_network" "network" {
  label  = "private-vpc-${var.CLUSTER_NAME}"
  region = "LON1"
}

resource "civo_firewall" "firewall" {
  name                 = "k3s-${var.CLUSTER_NAME}-firewall"
  create_default_rules = true
  network_id           = civo_network.network.id
}

resource "civo_firewall_rule" "http" {
  firewall_id = civo_firewall.firewall.id
  protocol    = "tcp"
  start_port  = "80"
  end_port    = "80"
  cidr        = ["0.0.0.0/0"]
  direction   = "ingress"
  action      = "allow"
  label       = "http"
  depends_on  = [civo_firewall.firewall]
}

resource "civo_firewall_rule" "https" {
  firewall_id = civo_firewall.firewall.id
  protocol    = "tcp"
  start_port  = "443"
  end_port    = "443"
  cidr        = ["0.0.0.0/0"]
  direction   = "ingress"
  action      = "allow"
  label       = "https"
  depends_on  = [civo_firewall.firewall]
}

resource "civo_firewall_rule" "k3s_api_server" {
  firewall_id = civo_firewall.firewall.id
  protocol    = "tcp"
  start_port  = "6443"
  end_port    = "6443"
  cidr        = [var.MY_IP_ADDRESS]
  direction   = "ingress"
  action      = "allow"
  label       = "k3s-api-server"
  depends_on  = [civo_firewall.firewall]
}

resource "civo_kubernetes_cluster" "cluster" {
  region       = "LON1"
  name         = var.CLUSTER_NAME
  applications = "Nginx,metrics-server,argo-cd,civo-cluster-autoscaler,cert-manager"
  firewall_id  = civo_firewall.firewall.id
  network_id   = civo_network.network.id

  pools {
    size       = element(data.civo_size.small.sizes, 1).name
    node_count = 3
  }
}
