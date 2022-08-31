copy "web_config" {
  source      = "./files/web"
  destination = data("web")
}

container "1-web" {
  depends_on = ["copy.consul_ca", "exec_remote.agent_consul_bootstrap", "copy.web_config"]

  network {
    name = "network.${var.cd_consul_network}"
  }

  image {
    name = "nicholasjackson/fake-service:vm-v0.24.2"
  }

  env {
    key   = "CONSUL_HTTP_TOKEN_FILE"
    value = "/config/web-agent.token"
  }

  env {
    key   = "NAME"
    value = "WEB Primary"
  }

  env {
    key   = "SERVICE_ID"
    value = "web-1"
  }

  volume {
    source      = data("certs")
    destination = "/certs"
  }

  volume {
    source      = "${data("agent_config")}/web-token-config.hcl"
    destination = "/config/token-config.hcl"
  }

  volume {
    source      = "${data("agent_config")}/web-agent.token"
    destination = "/config/web-agent.token"
  }

  volume {
    source      = "./files/agent-config.hcl"
    destination = "/config/config.hcl"
  }

  volume {
    source      = "${data("web")}/web-service-1.hcl"
    destination = "/config/web-service-1.hcl"
  }

  volume {
    source      = "${data("web")}/web-startup.sh"
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
    host   = 9090
    remote = 9090
  }
}
