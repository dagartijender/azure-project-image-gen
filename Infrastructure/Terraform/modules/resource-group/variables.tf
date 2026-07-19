variable "resource_group_name" {
  description = "Azure Resource Group Name"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "environment" {
  description = "Environment Name"
  type        = string
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "tags" {
  description = "Additional Tags"
  type        = map(string)
  default     = {}
}