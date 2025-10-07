# Locals za dynamic environment
locals {
  environment = terraform.workspace == "default" ? "dev" : terraform.workspace
  namespace   = "counterapp-${local.environment}"
}

# Namespace za našu aplikaciju
resource "kubernetes_namespace" "counterapp" {
  metadata {
    name = local.namespace
  }
}

# Backend Deployment
resource "kubernetes_deployment" "backend" {
  metadata {
    name      = "backend-deployment"
    namespace = local.namespace
    labels = {
      app = "counter-backend"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "counter-backend"
      }
    }

    template {
      metadata {
        labels = {
          app = "counter-backend"
        }
      }

      spec {
        image_pull_secrets {
          name = "dockerhub-secret"
        }
        container {
          name  = "counter-backend"
          image = var.backend_image
          port {
            container_port = 8000
          }
          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "256Mi"
            }
          }
        }
      }
    }
  }

  depends_on = [kubernetes_namespace.counterapp]
}

# Backend Service
resource "kubernetes_service" "backend" {
  metadata {
    name      = "backend-service"
    namespace = local.namespace
  }
  spec {
    selector = {
      app = "counter-backend"
    }
    port {
      port        = 8000
      target_port = 8000
    }
    type = "ClusterIP"
  }

  depends_on = [kubernetes_namespace.counterapp]
}

# Frontend Deployment
resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = "frontend-deployment"
    namespace = local.namespace
    labels = {
      app = "counter-frontend"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "counter-frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "counter-frontend"
        }
      }

      spec {
        image_pull_secrets {
          name = "dockerhub-secret"
        }
        container {
          name  = "counter-frontend"
          image = var.frontend_image
          port {
            container_port = 80
          }
          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "256Mi"
            }
          }
        }
      }
    }
  }

  depends_on = [kubernetes_namespace.counterapp]
}

# Frontend Service
resource "kubernetes_service" "frontend" {
  metadata {
    name      = "frontend-service"
    namespace = local.namespace
  }
  spec {
    selector = {
      app = "counter-frontend"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }

  depends_on = [kubernetes_namespace.counterapp]
}

# Ingress za aplikaciju
resource "kubernetes_ingress_v1" "counterapp" {
  metadata {
    name      = "counter-ingress"
    namespace = local.namespace
    annotations = {
      "nginx.ingress.kubernetes.io/ssl-redirect" = "false"
    }
  }

  spec {
    rule {
      host = "counter-${local.environment}.local"
      http {
        path {
          path = "/"
          backend {
            service {
              name = "frontend-service"
              port {
                number = 80
              }
            }
          }
        }
        path {
          path = "/api"
          backend {
            service {
              name = "backend-service"
              port {
                number = 8000
              }
            }
          }
        }
      }
    }
  }

  depends_on = [kubernetes_namespace.counterapp]
}
