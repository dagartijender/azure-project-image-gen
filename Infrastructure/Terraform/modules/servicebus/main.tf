##############################################
# Azure Service Bus Namespace
##############################################

resource "azurerm_servicebus_namespace" "this" {

  name                = var.namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku = "Premium"

  capacity = 1

  local_auth_enabled = false

  public_network_access_enabled = true

  minimum_tls_version = "1.2"

  tags = merge(
    {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}