##############################################
# Diagnostic Settings
##############################################

resource "azurerm_monitor_diagnostic_setting" "aks" {

  name = "aks-diagnostics"

  target_resource_id = var.aks_id

  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "kube-apiserver"
  }

  enabled_log {
    category = "kube-audit"
  }

  metric {
    category = "AllMetrics"
  }

}