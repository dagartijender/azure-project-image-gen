##############################################
# Azure Key Vault Secrets
##############################################

resource "azurerm_key_vault_secret" "openai_endpoint" {

  count = var.create_secrets ? 1 : 0

  name         = "openai-endpoint"
  value        = var.openai_endpoint
  key_vault_id = azurerm_key_vault.this.id
}

resource "azurerm_key_vault_secret" "openai_key" {

  count = var.create_secrets ? 1 : 0

  name         = "openai-key"
  value        = var.openai_key
  key_vault_id = azurerm_key_vault.this.id
}

resource "azurerm_key_vault_secret" "postgres_password" {

  count = var.create_secrets ? 1 : 0

  name         = "postgres-password"
  value        = var.postgres_password
  key_vault_id = azurerm_key_vault.this.id
}