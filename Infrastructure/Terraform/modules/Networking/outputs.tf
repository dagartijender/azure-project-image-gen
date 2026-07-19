output "vnet_id" {
  value = azurerm_virtual_network.this.id
}

output "vnet_name" {
  value = azurerm_virtual_network.this.name
}

output "aks_subnet_id" {
  value = azurerm_subnet.aks.id
}

output "appgw_subnet_id" {
  value = azurerm_subnet.appgw.id
}

output "bastion_subnet_id" {
  value = azurerm_subnet.bastion.id
}

output "aks_nsg_id" {
  value = azurerm_network_security_group.aks.id
}

output "appgw_nsg_id" {
  value = azurerm_network_security_group.appgw.id
}