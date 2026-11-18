locals {
  container_name = "${var.project_name}-web"
  network_name   = "${var.project_name}-network"
}

resource "docker_image" "nginx" {
  name         = var.image_name
  keep_locally = false
}

resource "docker_network" "application" {
  name = local.network_name
}

resource "docker_container" "web" {
  name  = local.container_name
  image = docker_image.nginx.image_id

  networks_advanced {
    name = docker_network.application.name
  }

  ports {
    internal = 80
    external = var.external_port
  }

  labels {
    label = "module"
    value = "web_service"
  }
}
