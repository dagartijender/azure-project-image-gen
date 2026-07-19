##############################################
# Origin Group
##############################################

resource "azurerm_cdn_frontdoor_origin_group" "this" {

  name                     = "aks-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id

  session_affinity_enabled = false

  health_probe {

    interval_in_seconds = 30

    path = "/health"

    protocol = "Https"

    request_type = "GET"

  }

  load_balancing {

    sample_size = 4

    successful_samples_required = 3

  }

}

##############################################
# Origin
##############################################

resource "azurerm_cdn_frontdoor_origin" "this" {

  name = "application-gateway"

  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.this.id

  enabled = true

  host_name = var.application_gateway_fqdn

  origin_host_header = var.application_gateway_fqdn

  http_port = 80

  https_port = 443

  priority = 1

  weight = 1000

  certificate_name_check_enabled = true

}