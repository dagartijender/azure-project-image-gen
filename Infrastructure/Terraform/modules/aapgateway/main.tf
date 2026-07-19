##############################################
# Public IP
##############################################

resource "azurerm_public_ip" "this" {

  name                = "${var.application_gateway_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
  sku               = "Standard"

  zones = ["1", "2", "3"]

  tags = var.tags
}

##############################################
# Application Gateway
##############################################

resource "azurerm_application_gateway" "this" {

  name                = var.application_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name

  zones = ["1", "2", "3"]

  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
  }

  autoscale_configuration {
    min_capacity = 2
    max_capacity = 10
  }

  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = "https-port"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "frontend-public"
    public_ip_address_id = azurerm_public_ip.this.id
  }

  ssl_certificate {
    name                = "ssl-cert"
    key_vault_secret_id = var.key_vault_certificate_secret_id
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