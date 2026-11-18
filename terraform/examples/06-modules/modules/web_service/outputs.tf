output "application_url" {
  description = "URL local del servicio web."
  value       = "http://localhost:${var.external_port}"
}

output "container_name" {
  description = "Nombre del contenedor creado."
  value       = docker_container.web.name
}
