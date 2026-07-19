output "namespace_id" {
  value = azurerm_servicebus_namespace.this.id
}

output "namespace_name" {
  value = azurerm_servicebus_namespace.this.name
}

output "image_generation_queue" {
  value = azurerm_servicebus_queue.image_generation.name
}

output "image_processing_queue" {
  value = azurerm_servicebus_queue.image_processing.name
}

output "notification_topic" {
  value = azurerm_servicebus_topic.notifications.name
}