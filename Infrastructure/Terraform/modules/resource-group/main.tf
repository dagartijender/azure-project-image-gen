resource "azurerm_resource_group" "project_gen_ai" {

  name     = var.resource_group_name
  location = var.location

  tags = merge(
    {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}
