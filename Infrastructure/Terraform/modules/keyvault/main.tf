##############################################
# Azure Key Vault
##############################################

resource "azurerm_key_vault" "this" {

  name                = var.key_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tenant_id = var.tenant_id

  sku_name = "standard"

  enable_rbac_authorization = true

  purge_protection_enabled = true

  soft_delete_retention_days = 90

  public_network_access_enabled = true

  tags = merge(
    {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    },
    var.tags
  )

}