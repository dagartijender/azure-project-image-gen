#############################################
# Azure Container Registry
#############################################

resource "azurerm_role_assignment" "acr_pull" {

  count = var.acr_id != "" ? 1 : 0

  scope                = var.acr_id
  role_definition_name = "AcrPull"

  principal_id = azurerm_user_assigned_identity.this.principal_id
}

#############################################
# Storage Blob
#############################################

resource "azurerm_role_assignment" "storage_blob" {

  count = var.storage_account_id != "" ? 1 : 0

  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"

  principal_id = azurerm_user_assigned_identity.this.principal_id
}

#############################################
# Key Vault
#############################################

resource "azurerm_role_assignment" "keyvault" {

  count = var.keyvault_id != "" ? 1 : 0

  scope                = var.keyvault_id
  role_definition_name = "Key Vault Secrets User"

  principal_id = azurerm_user_assigned_identity.this.principal_id
}

#############################################
# Service Bus Sender
#############################################

resource "azurerm_role_assignment" "sb_sender" {

  count = var.servicebus_namespace_id != "" ? 1 : 0

  scope                = var.servicebus_namespace_id
  role_definition_name = "Azure Service Bus Data Sender"

  principal_id = azurerm_user_assigned_identity.this.principal_id
}

#############################################
# Service Bus Receiver
#############################################

resource "azurerm_role_assignment" "sb_receiver" {

  count = var.servicebus_namespace_id != "" ? 1 : 0

  scope                = var.servicebus_namespace_id
  role_definition_name = "Azure Service Bus Data Receiver"

  principal_id = azurerm_user_assigned_identity.this.principal_id
}