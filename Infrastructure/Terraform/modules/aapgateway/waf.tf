##############################################
# Web Application Firewall
##############################################

waf_configuration {

  enabled = true

  firewall_mode = "Prevention"

  rule_set_type = "OWASP"

  rule_set_version = "3.2"

  request_body_check = true

  max_request_body_size_kb = 128

  file_upload_limit_mb = 100

}