variable "cluster_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "dns_prefix" {}
variable "subnet_id" {}
variable "acr_id" {}
variable "log_analytics_workspace_id" {}

variable "environment" {}
variable "project_name" {}

variable "kubernetes_version" {
  default = "1.31"
}

variable "system_node_vm_size" {
  default = "Standard_D4s_v5"
}

variable "system_node_count" {
  default = 2
}

variable "user_node_vm_size" {
  default = "Standard_D4s_v5"
}

variable "user_node_count" {
  default = 2
}

variable "tags" {
  default = {}
}