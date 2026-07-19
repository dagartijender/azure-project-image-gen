##############################################
# Resource Health Alert
##############################################

resource "azurerm_monitor_activity_log_alert" "resource_health" {

  name                = "resource-health-alert"

  resource_group_name = var.resource_group_name

  scopes = [
    var.subscription_id
  ]

  criteria {

    category = "ResourceHealth"

  }

  action {

    action_group_id = azurerm_monitor_action_group.this.id

  }

}