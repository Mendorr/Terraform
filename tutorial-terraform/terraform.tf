// 1. Archivo de configuración
// ANTES INSTALA EL PLUGIN DE TU IDE PARA TERRAFORM
// terraform.tf configura Terraform. Versiones, credenciales, proveedores y plugins a instalar...

// 1.1 PROVEEDOR
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

// 1.2 CONFIGURACIÓN

provider "docker" {}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.name
  name  = "nginx-test"
  ports {
    internal = 80
    external = 8080
  }
}