##############################################
# Azure Front Door Premium Profile
##############################################

resource "azurerm_cdn_frontdoor_profile" "this" {

  name                = var.frontdoor_name
  resource_group_name = var.resource_group_name
  sku_name            = "Premium_AzureFrontDoor"

  tags = merge(
    {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}

##############################################
# Endpoint
##############################################

resource "azurerm_cdn_frontdoor_endpoint" "this" {

  name                     = "${var.frontdoor_name}-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id

}