##############################################
# Route
##############################################

resource "azurerm_cdn_frontdoor_route" "this" {

  name = "default-route"

  cdn_frontdoor_endpoint_id = azurerm_cdn_frontdoor_endpoint.this.id

  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.this.id

  cdn_frontdoor_origin_ids = [
    azurerm_cdn_frontdoor_origin.this.id
  ]

  forwarding_protocol = "HttpsOnly"

  https_redirect_enabled = true

  supported_protocols = [
    "Http",
    "Https"
  ]

  patterns_to_match = [
    "/*"
  ]

  link_to_default_domain = true

}