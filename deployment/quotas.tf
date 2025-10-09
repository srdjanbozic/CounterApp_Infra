# Resource Quotas per environment 
resource "kubernetes_resource_quota" "env_quota" {
  metadata {
    name      = "env-quota"
    namespace = kubernetes_namespace.counterapp.metadata[0].name
  }

  spec {
    hard = {
      # CPU limits 
      "requests.cpu" = local.environment == "prod" ? "2" : local.environment == "qa" ? "1.5" : "1"
      "limits.cpu"   = local.environment == "prod" ? "3" : local.environment == "qa" ? "2.5" : "2"

      # Memory limits 
      "requests.memory" = local.environment == "prod" ? "3Gi" : local.environment == "qa" ? "2Gi" : "1Gi"
      "limits.memory"   = local.environment == "prod" ? "4Gi" : local.environment == "qa" ? "3Gi" : "2Gi"

      # Pod limits 
      "pods" = local.environment == "prod" ? "8" : local.environment == "qa" ? "5" : "4"

      # Storage limits
      "persistentvolumeclaims" = "5"
      "requests.storage"       = "20Gi"
    }
  }
}

# Limit Range 
resource "kubernetes_limit_range" "env_limits" {
  metadata {
    name      = "env-limits"
    namespace = kubernetes_namespace.counterapp.metadata[0].name
  }

  spec {
    limit {
      type = "Container"

      default = {
        cpu    = "200m"
        memory = "256Mi"
      }

      default_request = {
        cpu    = "100m"
        memory = "128Mi"
      }

      max = {
        cpu    = "1"
        memory = "1Gi"
      }

      min = {
        cpu    = "50m"
        memory = "64Mi"
      }
    }
  }
}