##############################################
# Azure Container Registry
##############################################

resource "azurerm_container_registry" "this" {

  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku = var.sku

  admin_enabled = var.admin_enabled

  public_network_access_enabled = var.public_network_access_enabled

  anonymous_pull_enabled = false

  tags = merge(
    {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}
