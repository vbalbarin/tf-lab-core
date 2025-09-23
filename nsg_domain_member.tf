locals {
  nsg_rules_domain_member_subnet = {
    "Allow_Bastion_Inbound" = {
      name                       = "Allow_Bastion_Inbound"
      access                     = "Allow"
      destination_address_prefix = "VirtualNetwork"
      destination_port_ranges    = ["22", "3389"]
      direction                  = "Inbound"
      priority                   = 150
      protocol                   = "Tcp"
      source_address_prefix      = module.virtualnetwork.subnets[local.subnet_names.azure_bastion].resource.body.properties.addressPrefixes[0]
      source_port_range          = "*"
    }
  }
}

# This is the module call
module "nsg_domain_member_subnet" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "~> 0.5.0"

  name                = local.resource_names["network_security_group_name_domain_member"]
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location

  tags = var.tags

  security_rules = local.nsg_rules_domain_member_subnet

  enable_telemetry = var.telemetry_enabled
}