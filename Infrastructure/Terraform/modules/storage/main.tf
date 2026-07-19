##############################################
# Azure Storage Account
##############################################

resource "azurerm_storage_account" "this" {

  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location

  account_tier             = "Standard"
  account_replication_type = "LRS"

  account_kind = "StorageV2"

  min_tls_version = "TLS1_2"

  https_traffic_only_enabled = true

  public_network_access_enabled = true

  shared_access_key_enabled = true

  allow_nested_items_to_be_public = false

  tags = merge(
    {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}