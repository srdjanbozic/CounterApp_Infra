variable "frontend_image" {
  description = "Frontend Docker image"
  type        = string
  default     = "zoddo16/counterapp-ui:latest"
}

variable "backend_image" {
  description = "Backend Docker image"
  type        = string
  default     = "zoddo16/counter-backend:latest"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}
# Test
