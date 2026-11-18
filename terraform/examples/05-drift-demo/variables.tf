variable "project_name" {
  description = "Nombre lógico del proyecto. Se usa para nombrar recursos."
  type        = string
  default     = "tf-demo"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Usá solo minúsculas, números y guiones."
  }
}

variable "image_name" {
  description = "Imagen Docker para el servicio web."
  type        = string
  default     = "nginx:alpine"
}

variable "external_port" {
  description = "Puerto publicado en el host."
  type        = number
  default     = 8080

  validation {
    condition     = var.external_port >= 1024 && var.external_port <= 65535
    error_message = "El puerto debe estar entre 1024 y 65535."
  }
}
