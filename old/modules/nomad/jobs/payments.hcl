job "payments-deployment" {
  datacenters = ["dc1"]
  type        = "service"

  group "jboss" {
    count = 1

    volume "artifacts" {
      type   = "host"
      source = "artifacts"
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    ephemeral_disk {
      size = 300
    }

    network {
      mode = "bridge"
      port "http" {
        to = "8080"
      }

      # dynamic port for the metrics
      port "metrics" {
        to = "9102"
      }

      port "admin" {
        to = "9990"
      }
    }

    # create a service so that promethues can scrape the metrics
    service {
      name = "payments-metrics"
      port = "metrics"
      tags = ["metrics"]
      meta {
        metrics    = "prometheus"
        job        = NOMAD_JOB_NAME
        datacenter = node.datacenter
      }
    }

    service {
      name = "payments-admin"
      port = "9990"

      connect {
        sidecar_service {
          proxy {}
        }
      }
    }

    service {
      name = "payments"
      port = "8080"

      connect {
        sidecar_service {
          proxy {
            # expose the metrics endpont 
            config {
              envoy_prometheus_bind_addr = "0.0.0.0:9102"
            }
          }
        }
      }
    }

    # /opt/jboss/wildfly/standalone/deployments

    task "jboss" {
      driver = "docker"

      config {
        image = "jboss/wildfly"
        ports = ["http"]
      }

      resources {
        cpu    = 500  # 500 MHz
        memory = 1024 # 256MB
      }

      volume_mount {
        volume      = "artifacts"
        destination = "/opt/jboss/wildfly/standalone/deployments"
      }
    }

    # envoy is bound to ip 127.0.0.2 however expose only accepts redirects to 127.0.0.1
    # run socat to redirect the envoy admin port to localhost
    task "socat" {
      driver = "docker"

      config {
        image = "alpine/socat"
        args = [
          "TCP-LISTEN:19002,fork,bind=127.0.0.1",
          "TCP:127.0.0.2:19002",
        ]
      }
    }
  }
}
