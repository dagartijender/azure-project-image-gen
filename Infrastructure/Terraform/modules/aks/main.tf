##############################################
# Azure Kubernetes Service
##############################################

resource "azurerm_kubernetes_cluster" "this" {

  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name

  dns_prefix = var.dns_prefix

  kubernetes_version = var.kubernetes_version

  sku_tier = "Standard"

  private_cluster_enabled = false

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  role_based_access_control_enabled = true

  local_account_disabled = true

  automatic_upgrade_channel = "stable"

  image_cleaner_enabled = true

  image_cleaner_interval_hours = 48

  azure_policy_enabled = true

  default_node_pool {

    name = "system"

    vm_size = var.system_node_vm_size

    node_count = var.system_node_count

    vnet_subnet_id = var.subnet_id

    type = "VirtualMachineScaleSets"

    auto_scaling_enabled = true

    min_count = 2

    max_count = 5

    os_disk_size_gb = 128

    only_critical_addons_enabled = true

  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {

    network_plugin = "azure"

    network_policy = "azure"

    load_balancer_sku = "standard"

    outbound_type = "loadBalancer"

  }

  oms_agent {

    log_analytics_workspace_id = var.log_analytics_workspace_id

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
