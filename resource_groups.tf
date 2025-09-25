resource "azurerm_resource_group" "network" {
  name     = local.resource_names["resource_group_network"]
  location = var.location

  tags = var.tags
}

resource "azurerm_resource_group" "domain_controller" {
  name     = local.resource_names["resource_group_domain_controller"]
  location = var.location

  tags = var.tags
}

resource "azurerm_resource_group" "domain_member" {
  name     = local.resource_names["resource_group_domain_member"]
  location = var.location

  tags = var.tags
}

resource "azurerm_resource_group" "support" {
  name     = local.resource_names["resource_group_support"]
  location = var.location

  tags = var.tags
}