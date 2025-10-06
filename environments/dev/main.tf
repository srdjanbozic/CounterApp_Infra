terraform {
  required_version = ">= 1.5.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30.0"
    }
  }

  backend "local" {
    path = "~/terraform-states/counterapp/dev/terraform.tfstate"
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}

module "namespace" {
  source = "../../modules/namespace"
  name   = "counterapp-dev"
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
