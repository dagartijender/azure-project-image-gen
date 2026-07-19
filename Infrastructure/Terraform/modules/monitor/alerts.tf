##############################################
# High CPU Alert
##############################################

resource "azurerm_monitor_metric_alert" "aks_cpu" {

  name                = "aks-high-cpu"

  resource_group_name = var.resource_group_name

  scopes = [
    var.aks_id
  ]

  description = "AKS CPU usage exceeded threshold"

  severity = 2

  frequency   = "PT1M"
  window_size = "PT5M"

  criteria {

    metric_namespace = "Microsoft.ContainerService/managedClusters"

    metric_name = "node_cpu_usage_percentage"

    aggregation = "Average"

    operator = "GreaterThan"

    threshold = 80

  }

  action {

    action_group_id = azurerm_monitor_action_group.this.id

  }

}