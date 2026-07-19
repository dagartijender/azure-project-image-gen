output "id" {
  value = azurerm_storage_account.this.id
}

output "name" {
  value = azurerm_storage_account.this.name
}

output "primary_blob_endpoint" {
  value = azurerm_storage_account.this.primary_blob_endpoint
}

output "images_container" {
  value = azurerm_storage_container.images.name
}

output "uploads_container" {
  value = azurerm_storage_container.uploads.name
}

output "logs_container" {
  value = azurerm_storage_container.logs.name
}