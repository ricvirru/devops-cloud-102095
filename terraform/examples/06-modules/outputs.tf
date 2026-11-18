output "application_url" {
  description = "URL del servicio expuesta por el módulo."
  value       = module.web_service.application_url
}

output "container_name" {
  description = "Nombre del contenedor creado dentro del módulo."
  value       = module.web_service.container_name
}
