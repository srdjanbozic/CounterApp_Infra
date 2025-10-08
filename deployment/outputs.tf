output "namespace" {
  value = kubernetes_namespace.counterapp.metadata[0].name
}

output "backend_release" {
  value = helm_release.counterapp_backend.name
}

output "frontend_release" {
  value = helm_release.counterapp_frontend.name
}

output "environment" {
  value = terraform.workspace
}
