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

# Create a firewall
resource "civo_firewall" "firewall" {
  name = "firewall"
}

resource "civo_firewall_rule" "k3s-api-server" {
  firewall_id = civo_firewall.firewall.id
  protocol    = "tcp"
  start_port  = "6443"
  end_port    = "6443"
  cidr        = [var.MY_IP_ADDRESS]
  direction   = "ingress"
  label       = "kubernetes-api-server"
  action      = "allow"
}

resource "civo_firewall_rule" "http" {
  firewall_id = civo_firewall.firewall.id
  protocol    = "tcp"
  start_port  = "80"
  end_port    = "80"
  cidr        = ["0.0.0.0/0"]
  direction   = "ingress"
  label       = "http"
  action      = "allow"
}

resource "civo_firewall_rule" "https" {
  firewall_id = civo_firewall.firewall.id
  protocol    = "tcp"
  start_port  = "443"
  end_port    = "443"
  cidr        = ["0.0.0.0/0"]
  direction   = "ingress"
  label       = "https"
  action      = "allow"
}

# Create a cluster
resource "civo_kubernetes_cluster" "cluster" {
  region = "LON1"
  name   = var.CLUSTER_NAME
  # applications = "Nginx,Cert Manager,Metrics Server,Civo cluster autoscaler,Argo CD"
  applications = "Nginx,metrics-server,argo-cd,civo-cluster-autoscaler,cert-manager"
  # applications = "Nginx,Metrics Server"
  firewall_id = civo_firewall.firewall.id
  pools {
    size       = element(data.civo_size.small.sizes, 0).name
    node_count = 3
  }
}
