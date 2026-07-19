##############################################
# Image Generation Queue
##############################################

resource "azurerm_servicebus_queue" "image_generation" {

  name = "image-generation"

  namespace_id = azurerm_servicebus_namespace.this.id

  max_delivery_count = 10

  lock_duration = "PT5M"

  default_message_ttl = "P14D"

  dead_lettering_on_message_expiration = true

}

##############################################
# Image Processing Queue
##############################################

resource "azurerm_servicebus_queue" "image_processing" {

  name = "image-processing"

  namespace_id = azurerm_servicebus_namespace.this.id

  max_delivery_count = 10

  lock_duration = "PT5M"

  default_message_ttl = "P14D"

}