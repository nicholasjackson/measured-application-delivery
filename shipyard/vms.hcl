variable "cd_consul_server_instances" {
  default = 1
}

variable "cd_consul_data" {
  default = data("consul")
}

variable "cd_consul_acls_enabled" {
  default = true
}

variable "cd_consul_tls_enabled" {
  default = true
}

variable "cd_consul_dc" {
  default = "vms"
}

variable "cd_consul_primary_dc" {
  default = "vms"
}

variable "cd_consul_network" {
  default = "local"
}

variable "cd_gateway_enabled" {
  default = true
}

variable "cd_gateway_ip" {
  default = "10.10.0.202"
}

variable "cd_consul_additional_volume" {
  default = {
    source      = data("agent_config")
    destination = "/files"
    type        = "bind"
  }
}

variable "consul_releaser_acl_token_file" {
  description = "location of the ACL token that can be used by Consul Release Controller"
  default     = "${var.cd_consul_data}/bootstrap.token"
}


module "vms" {
  source = "github.com/shipyard-run/blueprints?ref=e51d3ce48455b56edaf2a04e67182b846789daef/modules//consul-docker"
}
