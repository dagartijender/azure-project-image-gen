variable "key_vault_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "environment" {
  type = string
}

variable "project_name" {
  type = string
}

variable "create_secrets" {
  type    = bool
  default = false
}

variable "openai_endpoint" {
  type      = string
  default   = ""
  sensitive = true
}

variable "openai_key" {
  type      = string
  default   = ""
  sensitive = true
}

variable "postgres_password" {
  type      = string
  default   = ""
  sensitive = true
}

variable "tags" {
  type    = map(string)
  default = {}
}