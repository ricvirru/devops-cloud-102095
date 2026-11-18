output "application_urls" {
  description = "URLs locales de cada réplica."
  value = [
    for idx in range(var.replicas) :
    "http://localhost:${var.base_external_port + idx}"
  ]
}

output "container_names" {
  description = "Nombres de los contenedores creados."
  value       = docker_container.web[*].name
}
