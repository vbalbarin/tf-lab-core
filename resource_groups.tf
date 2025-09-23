resource "azurerm_resource_group" "network" {
  name     = local.resource_names["resource_group_network"]
  location = var.location

  tags = var.tags
}