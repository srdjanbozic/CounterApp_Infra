variable "frontend_image" {
  type    = string
  default = "zoddo16/counterapp-ui:latest"
}

variable "backend_image" {
  type    = string
  default = "zoddo16/counter-backend:latest"
}

variable "frontend_replicas" {
  type    = number
  default = 1
}

variable "backend_replicas" {
  type    = number
  default = 1
}
