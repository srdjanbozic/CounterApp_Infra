variable "frontend_image" {
  description = "Frontend Docker image for QA"
  type        = string
  default     = "zoddo16/counterapp-ui:qa"
}

variable "backend_image" {
  description = "Backend Docker image for QA"
  type        = string
  default     = "zoddo16/counter-backend:qa"
}

variable "frontend_replicas" {
  description = "Number of frontend replicas for QA"
  type        = number
  default     = 1
}

variable "backend_replicas" {
  description = "Number of backend replicas for QA"
  type        = number
  default     = 1
}
