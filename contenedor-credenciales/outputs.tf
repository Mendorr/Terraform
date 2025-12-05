output "container_name" {
  value = docker_container.web.name
}

output "container_port" {
  value = docker_container.web.ports[0].external
}

output "admin_password_set" {
  value     = "Contraseña configurada (valor sensible no visible)"
   sensitive = true
}

output "api_key_set" {
  value     = "API Key configurada (valor sensible no visible)"
  sensitive = true
}