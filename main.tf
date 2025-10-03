terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.30.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Namespace za našu aplikaciju
resource "kubernetes_namespace" "counterapp" {
  metadata {
    name = "counterapp"
  }
}

# Backend Deployment
resource "kubernetes_deployment" "backend" {
  metadata {
    name      = "backend-deployment"
    namespace = kubernetes_namespace.counterapp.metadata[0].name
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
          image = "zoddo16/counter-backend:latest"
          port {
            container_port = 8000
          }
        }
      }
    }
  }
}

# Backend Service
resource "kubernetes_service" "backend" {
  metadata {
    name      = "backend-service"
    namespace = kubernetes_namespace.counterapp.metadata[0].name
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
}

# Frontend Deployment
resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = "frontend-deployment"
    namespace = kubernetes_namespace.counterapp.metadata[0].name
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
          image = "zoddo16/counterapp-ui:latest"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

# Frontend Service
resource "kubernetes_service" "frontend" {
  metadata {
    name      = "frontend-service"
    namespace = kubernetes_namespace.counterapp.metadata[0].name
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
}

# Ingress za aplikaciju
resource "kubernetes_ingress_v1" "counterapp" {
  metadata {
    name      = "counter-ingress"
    namespace = kubernetes_namespace.counterapp.metadata[0].name
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
      "nginx.ingress.kubernetes.io/ssl-redirect"   = "false"
    }
  }

  spec {
    rule {
      host = "counter.local"
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
}
