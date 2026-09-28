output "workspace" {
  description = "Ambiente al que corresponde este estado."
  value       = terraform.workspace
}

output "instance_public_ip" {
  description = "IP pública del host."
  value       = aws_instance.app.public_ip
}

output "app_url" {
  description = "URL donde responde TicoMarket."
  value       = "http://${aws_instance.app.public_ip}:${var.app_port}"
}

output "ansible_group" {
  description = "Grupo del inventario dinámico que agrupa a esta instancia."
  value       = "env_${local.env}"
}
