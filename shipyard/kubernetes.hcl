variable "consul_k8s_cluster" {
  default = "kubernetes"
}

variable "consul_k8s_network" {
  default = "local"
}

variable "consul_datacenter" {
  default = "kubernetes"
}

variable "consul_primary_datacenter" {
  default = "vms"
}

variable "consul_primary_gateway" {
  default = "10.10.0.202:443"
}

variable "consul_mesh_gateway_enabled" {
  description = "Should mesh gateways be enabled?"
  default     = true
}

variable "consul_ingress_gateway_enabled" {
  description = "Enable ingress gateways"
  default     = true
}

variable "consul_mesh_gateway_address" {
  default = "10.10.0.210"
}

variable "consul_kubernetes_address" {
  default = "10.10.0.210"
}

variable "consul_federation_enabled" {
  description = "Should a federation be enabled?"
  default     = true
}

variable "consul_tls_enabled" {
  default = true
}

variable "consul_acls_enabled" {
  default = true
}

variable "consul_transparent_proxy_enabled" {
  description = "Enable the transparent proxy feature for then entire cluster for consul service mesh"
  default     = true
}

variable "consul_auto_inject_enabled" {
  description = "Enable the automatic injection of sidecar proxies for kubernetes pods"
  default     = true
}

variable "consul_ports_gateway" {
  default = 30443
}

# Shipyard is not smart enough to understand that this variable is defined in a module
# to use it in the interpolation for certs we need to redefine it.
variable "cd_consul_certs_data" {
  default = data("certs")
}

variable "cd_consul_data" {
  default = data("consul")
}

variable "consul_ca_cert_file" {
  default = "${var.cd_consul_certs_data}/cd_consul_ca.cert"
}

variable "consul_ca_key_file" {
  default = "${var.cd_consul_certs_data}/cd_consul_ca.key"
}

variable "consul_acl_token_file" {
  default = "${var.cd_consul_data}/replication.token"
}

# Ports for Kubernetes servers
variable "consul_ports_api" {
  default = 18501
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

variable "consul_release_controller_enabled" {
  description = "Should the Consul release controller be enabled?"
  default     = true
}

k8s_cluster "kubernetes" {
  driver = "k3s"

  nodes = 1

  network {
    name       = "network.${var.consul_k8s_network}"
    ip_address = var.consul_kubernetes_address
  }
}

# Create the secret consul-bootstrap-acl-token needed by 
# the release controller
template "release_acl_secret" {
  soruce = <<-EOF

  EOF

  destination = "${data("release_controller")}/bootstrap_acl.yaml"
}

output "KUBECONFIG" {
  value = k8s_config("kubernetes")
}

module "kubernetes_consul" {
  depends_on = ["module.vms"]

  source = "github.com/shipyard-run/blueprints?ref=891c937844bdbec673f5428b1a3c8bff4e207727/modules//kubernetes-consul"
}
