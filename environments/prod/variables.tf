variable "frontend_image" {
  description = "Frontend Docker image for PROD"
  type        = string
  default     = "zoddo16/counterapp-ui:prod"
}

variable "backend_image" {
  description = "Backend Docker image for PROD"
  type        = string
  default     = "zoddo16/counter-backend:prod"
}

variable "frontend_replicas" {
  description = "Number of frontend replicas for PROD"
  type        = number
  default     = 3
}

variable "backend_replicas" {
  description = "Number of backend replicas for PROD"
  type        = number
  default     = 3
}
