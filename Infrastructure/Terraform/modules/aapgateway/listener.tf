##############################################
# HTTPS Listener
##############################################

http_listener {

  name = "https-listener"

  frontend_ip_configuration_name = "frontend-public"

  frontend_port_name = "https-port"

  protocol = "Https"

  ssl_certificate_name = "ssl-cert"

}

##############################################
# Routing Rule
##############################################

request_routing_rule {

  name = "routing-rule"

  rule_type = "Basic"

  http_listener_name = "https-listener"

  backend_address_pool_name = "aks-backend"

  backend_http_settings_name = "https-settings"

  priority = 100

}