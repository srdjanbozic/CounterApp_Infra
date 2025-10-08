provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}

terraform {
  backend "local" {
    path = "~/terraform-states/counterapp/prod/terraform.tfstate"
  }
}

module "namespace" {
  source = "../../modules/namespace"
  name   = "counterapp-prod"
}

module "backend" {
  source        = "../../modules/backend"
  namespace     = module.namespace.name
  backend_image = var.backend_image
  replicas      = var.backend_replicas
}

module "frontend" {
  source         = "../../modules/frontend"
  namespace      = module.namespace.name
  frontend_image = var.frontend_image
  replicas       = var.frontend_replicas
}
