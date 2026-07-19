output "id" {
  description = "Container Registry ID"
  value       = azurerm_container_registry.this.id
}

output "name" {
  description = "Container Registry Name"
  value       = azurerm_container_registry.this.name
}

output "login_server" {
  description = "Container Registry Login Server"
  value       = azurerm_container_registry.this.login_server
}

output "resource_group_name" {
  description = "Resource Group Name"
  value       = azurerm_container_registry.this.resource_group_name
}