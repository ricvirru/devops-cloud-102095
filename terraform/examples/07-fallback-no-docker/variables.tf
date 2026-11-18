variable "project_name" {
  description = "Nombre lógico del ejemplo."
  type        = string
  default     = "tf-fallback-demo"
}

variable "version" {
  description = "Versión lógica del despliegue. Cambiala para mostrar replacement."
  type        = string
  default     = "v1"
}
