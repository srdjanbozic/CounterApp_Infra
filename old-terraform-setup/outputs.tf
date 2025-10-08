output "application_urls" {
  description = "URLs for accessing the application"
  value = {
    frontend    = "http://counter.local"
    backend_api = "http://counter.local/api"
  }
}

output "namespace" {
  description = "Kubernetes namespace"
  value       = kubernetes_namespace.counterapp.metadata[0].name
}

output "frontend_service" {
  description = "Frontend service details"
  value       = kubernetes_service.frontend.metadata[0].name
}

output "backend_service" {
  description = "Backend service details"
  value       = kubernetes_service.backend.metadata[0].name
}
