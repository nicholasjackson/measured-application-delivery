module "vm_app" {
  depends_on = ["module.vms"]
  source     = "./vm_app"
}

module "kubernetes_app" {
  depends_on = ["module.kubernetes_consul"]
  source     = "./kubernetes_app"
}
