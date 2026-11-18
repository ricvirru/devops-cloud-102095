variable "project_name" {
  description = "Nombre lógico del proyecto."
  type        = string
  default     = "tf-scale-demo"
}

variable "image_name" {
  description = "Imagen Docker para el servicio web."
  type        = string
  default     = "nginx:alpine"
}

variable "base_external_port" {
  description = "Primer puerto publicado en el host."
  type        = number
  default     = 8080
}

variable "replicas" {
  description = "Cantidad de contenedores web a crear."
  type        = number
  default     = 2

  validation {
    condition     = var.replicas >= 1 && var.replicas <= 5
    error_message = "Para esta demo usá entre 1 y 5 réplicas."
  }
}
