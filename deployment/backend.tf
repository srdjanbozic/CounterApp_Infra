terraform {
  backend "kubernetes" {
    secret_suffix    = "state"
    config_path      = "~/.kube/config"
    config_context   = "minikube"
    namespace        = "terraform-state"
  }
}
