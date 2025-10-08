# Namespace resource (kreiran jednom)
resource "kubernetes_namespace" "counterapp" {
  metadata {
    name = "counterapp-${terraform.workspace}"
  }
}

# Backend Helm Release
resource "helm_release" "counterapp_backend" {
  name             = "counterapp-backend-${terraform.workspace}"
  namespace        = "counterapp-${terraform.workspace}"
  chart            = "${path.module}/../counterapp-backend"
  values           = [file("${path.module}/../counterapp-backend/${terraform.workspace}-values.yaml")]
  
  atomic           = true
  cleanup_on_fail  = true
  timeout          = 600
  wait             = true
  
  force_update     = true
  create_namespace = false
  reuse_values     = false
  
  depends_on = [kubernetes_namespace.counterapp]
}

# Frontend Helm Release
resource "helm_release" "counterapp_frontend" {
  name             = "counterapp-frontend-${terraform.workspace}"
  namespace        = "counterapp-${terraform.workspace}"
  chart            = "${path.module}/../counterapp-frontend"
  values           = [file("${path.module}/../counterapp-frontend/${terraform.workspace}-values.yaml")]
  
  atomic           = true
  cleanup_on_fail  = true
  timeout          = 600
  wait             = true
  
  force_update     = true
  create_namespace = false
  reuse_values     = false
  
  depends_on = [kubernetes_namespace.counterapp]
}
