variable "project_name" {
  description = "Nombre lógico del servicio."
  type        = string
}

variable "image_name" {
  description = "Imagen Docker para el contenedor."
  type        = string
}

variable "external_port" {
  description = "Puerto publicado en el host."
  type        = number
}
