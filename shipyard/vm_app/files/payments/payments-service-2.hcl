service {
  name = "payments"
  id   = "payments-2"
  port = 9091
  tags = ["candidate"]

  meta = {
    version = "candidate"
  }

  checks = [
    {
      id       = "payments"
      name     = "HTTP API on port 9091"
      http     = "http://localhost:9091/health"
      interval = "10s"
    }
  ]
}
