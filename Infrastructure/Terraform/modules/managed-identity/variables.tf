variable "identity_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "acr_id" {
  type    = string
  default = ""
}

variable "storage_account_id" {
  type    = string
  default = ""
}

variable "keyvault_id" {
  type    = string
  default = ""
}

variable "servicebus_namespace_id" {
  type    = string
  default = ""
}

variable "environment" {
  type = string
}

variable "project_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}