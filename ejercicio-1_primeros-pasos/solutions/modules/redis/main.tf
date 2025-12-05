terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.2"
    }
  }
}
resource "docker_container" "redis" {
  name  = var.name
  image = var.image
  networks_advanced {
    name = var.network_name
  }
  ports {
    internal = var.internal_port
    external = var.external_port
  }
}