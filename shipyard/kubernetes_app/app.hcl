k8s_config "payments" {
  cluster = "k8s_cluster.kubernetes"

  paths = [
    "./files/defaults.yaml",
    "./files/payments.yaml",
    "./files/web.yaml",
  ]

  wait_until_ready = true
}
