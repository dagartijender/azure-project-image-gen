variable "resource_group_name" {
  type = string
}

variable "action_group_name" {
  type = string
}

variable "alert_email" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "aks_id" {
  type = string
}

variable "log_analytics_workspace_id" {
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