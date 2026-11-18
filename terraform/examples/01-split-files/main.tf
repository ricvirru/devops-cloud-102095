resource "docker_image" "nginx" {
  name         = "nginx:alpine"
  keep_locally = false
}

resource "docker_network" "application" {
  name = "tf-demo-network"
}

resource "docker_container" "web" {
  name  = "tf-demo-split-web"
  image = docker_image.nginx.image_id

  networks_advanced {
    name = docker_network.application.name
  }

  ports {
    internal = 80
    external = 8080
  }

  labels {
    label = "managed-by"
    value = "terraform"
  }
}
