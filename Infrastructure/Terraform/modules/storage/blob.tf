##############################################
# Images Container
##############################################

resource "azurerm_storage_container" "images" {

  name                  = "images"
  storage_account_id    = azurerm_storage_account.this.id

  container_access_type = "private"

}

##############################################
# Uploads Container
##############################################

resource "azurerm_storage_container" "uploads" {

  name                  = "uploads"
  storage_account_id    = azurerm_storage_account.this.id

  container_access_type = "private"

}

##############################################
# Logs Container
##############################################

resource "azurerm_storage_container" "logs" {

  name                  = "logs"
  storage_account_id    = azurerm_storage_account.this.id

  container_access_type = "private"

}