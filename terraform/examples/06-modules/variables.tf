variable "project_name" {
  description = "Nombre del proyecto usado por el módulo."
  type        = string
  default     = "tf-module-demo"
}

variable "external_port" {
  description = "Puerto publicado por el módulo web."
  type        = number
  default     = 8080
}
