terraform {
  required_providers {
    docker = {
        source = "kreuzwerker/docker"
        version = "~> 3.0"
    }
  }
}

resource "docker_image" "nginx" {
  name = "nginx:alpine"
  #name = var.nginx_image
}

resource "docker_container" "web" {
    name = "nginx-web-server"
    image = docker_image.nginx.image_id

    ports {
        internal = 80
        external = 4000
        #external = var.nginx_port
    }

    env = [
        "ADMIN_PASSWORD=SuperSecretAdmin123!",
        "API_KEY=AKIAIOSFODNN7EXAMPLE"
        #"ADMIN_PASSWORD=${var.admin_password}",
        #"API_KEY=${var.api_key}"
    ]
}