variable "nginx_image" {
  description = "Imagen de Nginx a utilizar"
  #default     = "nginx:alpine"
}

variable "nginx_port" {
  description = "Puerto para el contenedor Nginx"
  #default     = 8080
}

variable "admin_password" {
  description = "Contraseña de administración"
  type        = string
  #sensitive   = true
}

variable "api_key" {
  description = "Clave API para servicios internos"
  type        = string
  #sensitive   = true
}