variable "nginx_image" {
  type    = string
  default = "nginx:latest"
}

variable "nginx_port" {
  type    = number
  default = 8080
}