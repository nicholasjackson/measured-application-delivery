variable "consul_k8s_cluster" {
  default = "kubernetes"
}

variable "consul_k8s_network" {
  default = "dc1"
}

variable "consul_datacenter" {
  default = "kubernetes"
}

variable "consul_primary_datacenter" {
  default = "dc1"
}

variable "consul_primary_gateway" {
  default = "10.5.0.100:443"
}

variable "consul_mesh_gateway_enabled" {
  description = "Should mesh gateways be enabled?"
  default     = true
}

variable "consul_mesh_gateway_address" {
  default = "10.5.0.210"
}

variable "consul_kubernetes_address" {
  default = "10.5.0.210"
}

variable "consul_federation_enabled" {
  description = "Should a federation be enabled?"
  default     = false
}

variable "consul_tls_enabled" {
  default = false
}

variable "consul_acls_enabled" {
  default = false
}

variable "consul_transparent_proxy_enabled" {
  description = "Enable the transparent proxy feature for then entire cluster for consul service mesh"
  default     = false
}

variable "consul_ports_gateway" {
  default = 30443
}

variable "consul_release_controller_enabled" {
  default = false
}

# Ports for Kubernetes servers
variable "consul_ports_api" {
  default = 18500
}

variable "consul_ports_rpc" {
  default = 18300
}

variable "consul_ports_lan" {
  default = 18301
}

# Disable the output variables as these are set by the docker consul too
variable "consul_set_outputs" {
  default = false
}

variable "consul_monitoring_enabled" {
  default = false
}

k8s_cluster "kubernetes" {
  driver = "k3s"

  nodes = 1

  network {
    name       = "network.${var.consul_k8s_network}"
    ip_address = var.consul_kubernetes_address
  }
}

output "KUBECONFIG" {
  value = k8s_config("kubernetes")
}

module "kubernetes_consul" {
  depends_on = ["module.consul_nomad"]
  source     = "github.com/shipyard-run/blueprints?ref=891c937844bdbec673f5428b1a3c8bff4e207727/modules//kubernetes-consul"
}
