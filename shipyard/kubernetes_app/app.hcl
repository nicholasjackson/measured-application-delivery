k8s_config "application" {
  cluster = "k8s_cluster.kubernetes"

  paths = [
    "${file_dir()}/files"
  ]

  wait_until_ready = true
}
