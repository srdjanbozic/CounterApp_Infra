variable "namespace" {
  type = string
}
variable "frontend_image" {
  type = string
}
variable "replicas" {
  type    = number
  default = 2
}

resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = "frontend-deployment"
    namespace = var.namespace
    labels    = { app = "counter-frontend" }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = { app = "counter-frontend" }
    }

    template {
      metadata {
        labels = { app = "counter-frontend" }
      }

      spec {
        container {
          name  = "counter-frontend"
          image = var.frontend_image
          port { container_port = 80 }
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name      = "frontend-service"
    namespace = var.namespace
  }
  spec {
    selector = { app = "counter-frontend" }
    port {
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}

output "service_name" {
  value = kubernetes_service.frontend.metadata[0].name
}
