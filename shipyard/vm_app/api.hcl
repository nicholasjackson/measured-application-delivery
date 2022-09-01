copy "api_config" {
  source      = "./files/api"
  destination = data("api")
}

container "1-api" {
  depends_on = ["copy.consul_ca", "exec_remote.agent_consul_bootstrap", "copy.api_config"]

  network {
    name = "network.${var.cd_consul_network}"
  }

  image {
    name = "nicholasjackson/fake-service:vm-v0.24.2"
  }

  env {
    key   = "CONSUL_HTTP_TOKEN_FILE"
    value = "/config/api-agent.token"
  }

  env {
    key   = "NAME"
    value = "API V1 VM"
  }

  env {
    key   = "SERVICE_ID"
    value = "api-1"
  }

  volume {
    source      = data("certs")
    destination = "/certs"
  }

  volume {
    source      = "${data("agent_config")}/api-token-config.hcl"
    destination = "/config/token-config.hcl"
  }

  volume {
    source      = "${data("agent_config")}/api-agent.token"
    destination = "/config/api-agent.token"
  }

  volume {
    source      = "./files/agent-config.hcl"
    destination = "/config/config.hcl"
  }

  volume {
    source      = "${data("api")}/api-service-1.hcl"
    destination = "/config/api-service-1.hcl"
  }

  volume {
    source      = "${data("api")}/api-startup.sh"
    destination = "/app/startup.sh"
  }

  volume {
    source      = "./files"
    destination = "/files"
  }

  # Override the default supervisor config
  volume {
    source      = "./files/supervisor.conf"
    destination = "/etc/supervisor/conf.d/fake-service.conf"
  }

  port {
    local  = 9090
    host   = 19090
    remote = 9090
  }
}
