variable "cn_nomad_client_host_volume" {
  default = {
    name        = "data"
    source      = data("nomad_data")
    destination = "/data"
    type        = "bind"
  }
}

variable "cn_network" {
  default = "dc1"
}

variable "pack_folder" {
  default = "${file_dir()}/packs"
}

variable "cn_nomad_cluster_name" {
  default = "nomad_cluster.local"
}

variable "cn_nomad_client_nodes" {
  default = 0
}

variable "cn_nomad_server_ip" {
  default = "10.5.0.100"
}

variable "cn_nomad_version" {
  default = "1.3.1"
}

variable "cn_nomad_client_config" {
  default = "${data("nomad_config")}/client.hcl"
}

variable "install_controller" {
  default = "docker"
}

module "consul_nomad" {
  #source = "github.com/shipyard-run/blueprints?ref=694e825167a05d6ae035a0b91f90ee7e8b2d2384/modules//consul-nomad"
  source = "/home/nicj/go/src/github.com/shipyard-run/blueprints/modules//consul-nomad"
}

exec_remote "proxy_defaults" {
  depends_on = ["module.consul_nomad"]

  image {
    name = "shipyardrun/hashicorp-tools:v0.9.0"
  }

  network {
    name = "network.dc1"
  }

  cmd = "/bin/bash"
  args = [
    "set_defaults.sh"
  ]

  # Mount a volume containing the config
  volume {
    source      = "./consul_config"
    destination = "/config"
  }

  working_directory = "/config"

  env {
    key   = "CONSUL_HTTP_ADDR"
    value = "http://1.consul.server.container.shipyard.run:8500"
  }
}

nomad_job "ingress" {
  depends_on = ["exec_remote.proxy_defaults", "module.monitoring", "module.controller"]

  cluster = var.cn_nomad_cluster_name
  paths = [
    "${file_dir()}/jobs/ingress.hcl",
  ]
}

nomad_ingress "ingress-http" {
  cluster = var.cn_nomad_cluster_name
  job     = "ingress"
  group   = "ingress"
  task    = "ingress"

  network {
    name = "network.dc1"
  }

  port {
    local  = 18080
    remote = "http"
    host   = 18080
  }
}

module "monitoring" {
  depends_on = ["module.consul_nomad", "exec_remote.proxy_defaults"]
  source     = "./modules/monitoring"
}

module "controller" {
  depends_on = ["module.consul_nomad", "exec_remote.proxy_defaults"]

  source = "./modules/releaser"
}
