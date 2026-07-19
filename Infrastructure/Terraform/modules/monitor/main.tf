##############################################
# Azure Monitor Action Group
##############################################

resource "azurerm_monitor_action_group" "this" {

  name                = var.action_group_name
  resource_group_name = var.resource_group_name
  short_name          = "AIMON"

  email_receiver {

    name                    = "platform-team"

    email_address           = var.alert_email

    use_common_alert_schema = true
  }

  tags = merge(
    {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    },
    var.tags
  )

}