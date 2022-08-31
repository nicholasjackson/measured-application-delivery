network "dc1" {
  subnet = "10.5.0.0/16"
}

module "nomad" {
  source = "./modules/nomad"
}

module "kubernetes" {
  depends_on = ["module.nomad"]

  source = "./modules/kubernetes"
}
