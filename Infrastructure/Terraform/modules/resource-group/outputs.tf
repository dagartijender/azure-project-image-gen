output "name" {
  description = "Resource Group Name"
  value       = azurerm_resource_group.this.name
}

output "id" {
  description = "Resource Group ID"
  value       = azurerm_resource_group.this.id
}

output "location" {
  description = "Azure Region"
  value       = azurerm_resource_group.this.location
}