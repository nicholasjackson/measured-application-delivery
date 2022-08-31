copy "nginx_config" {
  source      = "./files/nginx"
  destination = data("nginx")
}

container "nginx" {
  depends_on = ["copy.consul_ca", "exec_remote.agent_consul_bootstrap", "copy.nginx_config"]

  network {
    name = "network.${var.cd_consul_network}"
  }

  image {
    name = "nicholasjackson/nginx-consul:v0.1.0"
  }

  env_var = {
    CONSUL_HTTP_TOKEN_FILE = "/config/nginx-agent.token"
    UPSTREAM_URIS          = "http://api.service.consul:9090"
  }

  volume {
    source      = "${data("agent_config")}/nginx-agent.token"
    destination = "/config/nginx-agent.token"
  }

  volume {
    source      = data("certs")
    destination = "/certs"
  }

  volume {
    source      = "${data("agent_config")}/nginx-token-config.hcl"
    destination = "/config/token-config.hcl"
  }

  volume {
    source      = "./files/agent-config.hcl"
    destination = "/config/config.hcl"
  }

  volume {
    source      = "${data("nginx")}/nginx-1.hcl"
    destination = "/config/nginx-1.hcl"
  }

  volume {
    source      = "${data("nginx")}/nginx.ctmpl"
    destination = "/etc/consul-template/nginx.ctmpl"
  }

  port {
    local  = 80
    host   = 8081
    remote = 80
  }
}




