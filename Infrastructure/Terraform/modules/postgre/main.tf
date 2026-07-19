##############################################
# PostgreSQL Flexible Server
##############################################

resource "azurerm_postgresql_flexible_server" "this" {

  name                   = var.server_name
  resource_group_name    = var.resource_group_name
  location               = var.location

  administrator_login    = var.admin_username
  administrator_password = var.admin_password

  version = var.postgres_version

  storage_mb = var.storage_mb

  sku_name = var.sku_name

  backup_retention_days = 7

  geo_redundant_backup_enabled = false

  zone = "1"

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