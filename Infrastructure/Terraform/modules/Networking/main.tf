##############################################
# Virtual Network
##############################################

resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name

  address_space = var.vnet_address_space

  tags = var.tags
}

##############################################
# AKS Subnet
##############################################

resource "azurerm_subnet" "aks" {

  name                 = var.aks_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name

  address_prefixes = [var.aks_subnet_prefix]

}

##############################################
# Application Gateway Subnet
##############################################

resource "azurerm_subnet" "appgw" {

  name                 = var.appgw_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name

  address_prefixes = [var.appgw_subnet_prefix]

}

##############################################
# Azure Bastion Subnet
##############################################

resource "azurerm_subnet" "bastion" {

  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name

  address_prefixes = [var.bastion_subnet_prefix]

}

##############################################
# AKS NSG
##############################################

resource "azurerm_network_security_group" "aks" {

  name                = "${var.project_name}-aks-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

##############################################
# Application Gateway NSG
##############################################

resource "azurerm_network_security_group" "appgw" {

  name                = "${var.project_name}-appgw-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

##############################################
# Bastion NSG
##############################################

resource "azurerm_network_security_group" "bastion" {

  name                = "${var.project_name}-bastion-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

##############################################
# NSG Association - AKS
##############################################

resource "azurerm_subnet_network_security_group_association" "aks" {

  subnet_id                 = azurerm_subnet.aks.id
  network_security_group_id = azurerm_network_security_group.aks.id

}

##############################################
# NSG Association - App Gateway
##############################################

resource "azurerm_subnet_network_security_group_association" "appgw" {

  subnet_id                 = azurerm_subnet.appgw.id
  network_security_group_id = azurerm_network_security_group.appgw.id

}

##############################################
# NSG Association - Bastion
##############################################

resource "azurerm_subnet_network_security_group_association" "bastion" {

  subnet_id                 = azurerm_subnet.bastion.id
  network_security_group_id = azurerm_network_security_group.bastion.id

}
