service {
  name = "nginx"
  id   = "nginx-1"
  port = 80
  tags = ["loadbalancer"]

  checks = [
    {
      id       = "nginx"
      name     = "HTTP on port 80"
      http     = "http://localhost"
      interval = "10s"
    }
  ]
}
