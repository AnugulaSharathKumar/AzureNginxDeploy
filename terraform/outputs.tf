output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "container_registry_name" {
  description = "Name of the container registry"
  value       = azurerm_container_registry.acr.name
}

output "container_registry_url" {
  description = "URL of the container registry"
  value       = azurerm_container_registry.acr.login_server
}

output "webapp_url" {
  description = "URL to access the web application"
  value       = "http://${azurerm_container_group.webapp.fqdn}"
}

output "container_instance_name" {
  description = "Name of the container instance"
  value       = azurerm_container_group.webapp.name
}

output "container_instance_id" {
  description = "ID of the container instance"
  value       = azurerm_container_group.webapp.id
}