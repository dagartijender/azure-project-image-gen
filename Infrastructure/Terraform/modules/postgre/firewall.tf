##############################################
# Firewall Rule
##############################################

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure" {

  name = "AllowAzureServices"

  server_id = azurerm_postgresql_flexible_server.this.id

  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"

}
#Production recommendation: Instead of opening access broadly, use Private Endpoints and private DNS with AKS. Firewall rules are mainly useful for development or testing