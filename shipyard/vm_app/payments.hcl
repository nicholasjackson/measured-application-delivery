copy "payments_config" {
  source      = "./files/payments"
  destination = data("payments")
}

container "1-payments" {
  depends_on = ["copy.consul_ca", "exec_remote.agent_consul_bootstrap", "copy.payments_config"]

  network {
    name = "network.${var.cd_consul_network}"
  }

  image {
    name = "nicholasjackson/fake-service:vm-v0.24.2"
  }

  env {
    key   = "NAME"
    value = "Payments - 1 (primary)"
  }

  env {
    key   = "SERVICE_ID"
    value = "payments-1"
  }

  volume {
    source      = data("certs")
    destination = "/certs"
  }

  volume {
    source      = "${data("agent_config")}/payments-token-config.hcl"
    destination = "/config/token-config.hcl"
  }

  volume {
    source      = "./files/agent-config.hcl"
    destination = "/config/config.hcl"
  }

  volume {
    source      = "${data("payments")}/payments-service-1.hcl"
    destination = "/config/payments-service-1.hcl"
  }

  volume {
    source      = "${data("payments")}/payments-startup.sh"
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
}

container "2-payments" {
  depends_on = ["copy.consul_ca", "exec_remote.agent_consul_bootstrap", "copy.payments_config"]

  network {
    name = "network.${var.cd_consul_network}"
  }

  image {
    name = "nicholasjackson/fake-service:vm-v0.24.2"
  }

  env {
    key   = "LISTEN_ADDR"
    value = "0.0.0.0:9091"
  }

  env {
    key   = "NAME"
    value = "Payments - 2 (candidate)"
  }

  env {
    key   = "SERVICE_ID"
    value = "payments-2"
  }

  volume {
    source      = data("certs")
    destination = "/certs"
  }

  volume {
    source      = "${data("agent_config")}/payments-token-config.hcl"
    destination = "/config/payments-token-config.hcl"
  }

  volume {
    source      = "./files/agent-config.hcl"
    destination = "/config/config.hcl"
  }

  volume {
    source      = "${data("payments")}/payments-service-2.hcl"
    destination = "/config/payments-service-2.hcl"
  }

  volume {
    source      = "${data("payments")}/payments-startup.sh"
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
}

container "3-payments" {
  depends_on = ["copy.consul_ca", "exec_remote.agent_consul_bootstrap", "copy.payments_config"]

  network {
    name = "network.${var.cd_consul_network}"
  }

  image {
    name = "nicholasjackson/fake-service:vm-v0.24.2"
  }

  env {
    key   = "NAME"
    value = "Payments - 3 (primary)"
  }

  env {
    key   = "SERVICE_ID"
    value = "payments-3"
  }

  volume {
    source      = data("certs")
    destination = "/certs"
  }

  volume {
    source      = "${data("agent_config")}/payments-token-config.hcl"
    destination = "/config/token-config.hcl"
  }

  volume {
    source      = "./files/agent-config.hcl"
    destination = "/config/config.hcl"
  }

  volume {
    source      = "${data("payments")}/payments-service-3.hcl"
    destination = "/config/payments-service-3.hcl"
  }

  volume {
    source      = "${data("payments")}/payments-startup.sh"
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
}
