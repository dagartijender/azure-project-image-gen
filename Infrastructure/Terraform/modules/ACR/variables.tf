variable "acr_name" {
  description = "Azure Container Registry Name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "sku" {
  description = "ACR SKU"

  type    = string
  default = "Premium"
}

variable "admin_enabled" {
  description = "Enable Admin User"

  type    = bool
  default = false
}

variable "public_network_access_enabled" {
  description = "Enable Public Network Access"

  type    = bool
  default = true
}

variable "tags" {
  description = "Resource Tags"

  type    = map(string)
  default = {}
}