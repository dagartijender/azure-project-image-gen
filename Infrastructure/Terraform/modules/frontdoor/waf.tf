##############################################
# WAF Policy
##############################################

resource "azurerm_cdn_frontdoor_firewall_policy" "this" {

  name                = "${var.frontdoor_name}-waf"
  resource_group_name = var.resource_group_name
  sku_name            = "Premium_AzureFrontDoor"

  enabled = true

  mode = "Prevention"

  custom_block_response_status_code = 403

  managed_rule {

    type    = "DefaultRuleSet"
    version = "2.1"

  }

}