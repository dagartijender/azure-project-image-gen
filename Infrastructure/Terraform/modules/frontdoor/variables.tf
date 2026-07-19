variable "frontdoor_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "application_gateway_fqdn" {
  type = string
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