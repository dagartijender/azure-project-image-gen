##############################################
# Backend Pool
##############################################

backend_address_pool {

  name = "aks-backend"

  ip_addresses = [
    var.backend_private_ip
  ]

}

##############################################
# Backend Settings
##############################################

backend_http_settings {

  name = "https-settings"

  protocol = "Https"

  port = 443

  cookie_based_affinity = "Disabled"

  request_timeout = 60

  probe_name = "aks-health"

}

##############################################
# Health Probe
##############################################

probe {

  name = "aks-health"

  protocol = "Https"

  path = "/health"

  interval = 30

  timeout = 30

  unhealthy_threshold = 3

}