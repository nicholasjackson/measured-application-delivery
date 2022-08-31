service {
  name = "payments"
  id   = "payments-1"
  port = 9090
  tags = ["primary"]

  meta = {
    version = "primary"
  }

  checks = [
    {
      id       = "payments"
      name     = "HTTP API on port 9090"
      http     = "http://localhost:9090/health"
      interval = "10s"
    }
  ]

  connect {
    sidecar_service {
      proxy {}
    }
  }
}
