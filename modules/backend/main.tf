variable "namespace" {
  type = string
}
variable "backend_image" {
  type = string
}
variable "replicas" {
  type    = number
  default = 2
}

resource "kubernetes_deployment" "backend" {
  metadata {
    name      = "backend-deployment"
    namespace = var.namespace
    labels    = { app = "counter-backend" }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = { app = "counter-backend" }
    }

    template {
      metadata {
        labels = { app = "counter-backend" }
      }

      spec {
        container {
          name  = "counter-backend"
          image = var.backend_image
          port { container_port = 8000 }
        }
      }
    }
  }
}

resource "kubernetes_service" "backend" {
  metadata {
    name      = "backend-service"
    namespace = var.namespace
  }
  spec {
    selector = { app = "counter-backend" }
    port {
      port        = 8000
      target_port = 8000
    }
    type = "ClusterIP"
  }
}

output "service_name" {
  value = kubernetes_service.backend.metadata[0].name
}
