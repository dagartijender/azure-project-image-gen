##############################################
# User Node Pool
##############################################

resource "azurerm_kubernetes_cluster_node_pool" "user" {

  name = "user"

  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id

  vm_size = var.user_node_vm_size

  node_count = var.user_node_count

  vnet_subnet_id = var.subnet_id

  auto_scaling_enabled = true

  min_count = 2

  max_count = 10

  mode = "User"

  os_disk_size_gb = 128

  orchestrator_version = var.kubernetes_version

  tags = var.tags

}