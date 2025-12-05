output "nginx_url" {
  value = "http://localhost:${var.nginx_port}"
}

output "redis_container" {
  value = module.redis.container_name
}