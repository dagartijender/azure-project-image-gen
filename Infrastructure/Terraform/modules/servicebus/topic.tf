##############################################
# Notification Topic
##############################################

resource "azurerm_servicebus_topic" "notifications" {

  name = "notifications"

  namespace_id = azurerm_servicebus_namespace.this.id

}

##############################################
# Email Subscription
##############################################

resource "azurerm_servicebus_subscription" "email" {

  name = "email"

  topic_id = azurerm_servicebus_topic.notifications.id

  max_delivery_count = 10

}

##############################################
# Webhook Subscription
##############################################

resource "azurerm_servicebus_subscription" "webhook" {

  name = "webhook"

  topic_id = azurerm_servicebus_topic.notifications.id

}