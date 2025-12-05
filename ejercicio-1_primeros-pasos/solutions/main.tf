// 1. Proveedores - provider - providers.tf
// Un proveedor ofrece servicios de despliegue.
// Están implementados en GO.
// Los proveedores pueden tener configuraciones distintas.
// Las implementaciones lo único que hacen es traducir de HCL al CLI del servicio.

terraform {
  # Declaración de proveedores requeridos
  required_providers {
    docker = {
      source  = "kreuzwerker/docker" # Ubicación del provider en el Terraform Registry
      version = "~> 3.0"             # Se usará cualquier versión compatible con la 3.x
    }
  }
}

# Configuración del provider Docker
provider "docker" {
  # Este bloque se puede usar para parámetros adicionales si fuera necesario
  # En local, la configuración por defecto conecta con el Docker Engine local
}

resource "docker_network" "tutorial_net" {
  name = "tutorial-network"
}

resource "docker_container" "nginx" {
  name  = "tutorial-nginx"
  image = var.nginx_image
  networks_advanced {
    name = docker_network.tutorial_net.name
  }
  ports {
    internal = 80
    external = var.nginx_port
  }
}

module "redis" {
  source        = "./modules/redis"
  name          = "tutorial-redis"
  image         = "redis:7.0"
  internal_port = 6379
  external_port = 6379
  network_name = docker_network.tutorial_net.name
}