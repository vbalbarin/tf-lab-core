locals {
  // TODO: Consider generating from a custom map with only the source, port, and protocol
  nsg_rules_domain_controller_subnet = {
    "Allow_Bastion_Inbound" = {
      name                       = "Allow_Bastion_Inbound"
      access                     = "Allow"
      destination_address_prefix = module.virtualnetwork.subnets[local.subnet_names.domain_controller].resource.body.properties.addressPrefixes[0]
      destination_port_ranges    = ["22", "3389"]
      direction                  = "Inbound"
      priority                   = 150
      protocol                   = "Tcp"
      source_address_prefix      = module.virtualnetwork.subnets[local.subnet_names.azure_bastion].resource.body.properties.addressPrefixes[0]
      source_port_range          = "*"
    }
    "Allow_NTP_Udp_Inbound" = {
      name                       = "Allow_NTP_Udp_Inbound"
      access                     = "Allow"
      destination_address_prefix = module.virtualnetwork.subnets[local.subnet_names.domain_controller].resource.body.properties.addressPrefixes[0]
      destination_port_ranges    = ["123"]
      direction                  = "Inbound"
      priority                   = 200
      protocol                   = "Udp"
      source_address_prefix      = module.virtualnetwork.subnets[local.subnet_names.domain_member].resource.body.properties.addressPrefixes[0]
      source_port_range          = "*"
    }
    "Allow_RPC_EndpointMgr_Tcp_Inbound" = {
      name                       = "Allow_RPC_EndpointMgr_Tcp_Inbound"
      access                     = "Allow"
      destination_address_prefix = module.virtualnetwork.subnets[local.subnet_names.domain_controller].resource.body.properties.addressPrefixes[0]
      destination_port_ranges    = ["135"]
      direction                  = "Inbound"
      priority                   = 205
      protocol                   = "Tcp"
      source_address_prefix      = module.virtualnetwork.subnets[local.subnet_names.domain_member].resource.body.properties.addressPrefixes[0]
      source_port_range          = "*"
    }
    "Allow_KerberosPasswordChange_Tcp_Inbound" = {
      name                       = "Allow_KerberosPasswordChange_Tcp_Inbound"
      access                     = "Allow"
      destination_address_prefix = module.virtualnetwork.subnets[local.subnet_names.domain_controller].resource.body.properties.addressPrefixes[0]
      destination_port_ranges    = ["464"]
      direction                  = "Inbound"
      priority                   = 210
      protocol                   = "Tcp"
      source_address_prefix      = module.virtualnetwork.subnets[local.subnet_names.domain_member].resource.body.properties.addressPrefixes[0]
      source_port_range          = "*"
    }
    "Allow_KerberosPasswordChange_Udp_Inbound" = {
      name                       = "Allow_KerberosPasswordChange_Udp_Inbound"
      access                     = "Allow"
      destination_address_prefix = module.virtualnetwork.subnets[local.subnet_names.domain_controller].resource.body.properties.addressPrefixes[0]
      destination_port_ranges    = ["464"]
      direction                  = "Inbound"
      priority                   = 215
      protocol                   = "Udp"
      source_address_prefix      = module.virtualnetwork.subnets[local.subnet_names.domain_member].resource.body.properties.addressPrefixes[0]
      source_port_range          = "*"
    }
    "Allow_LDAP_Tcp_Inbound" = {
      name                       = "Allow_LDAP_Tcp_Inbound"
      access                     = "Allow"
      destination_address_prefix = module.virtualnetwork.subnets[local.subnet_names.domain_controller].resource.body.properties.addressPrefixes[0]
      destination_port_ranges    = ["389"]
      direction                  = "Inbound"
      priority                   = 220
      protocol                   = "Tcp"
      source_address_prefix      = module.virtualnetwork.subnets[local.subnet_names.domain_member].resource.body.properties.addressPrefixes[0]
      source_port_range          = "*"
    }
    "Allow_LDAPS_Tcp_Inbound" = {
      name                       = "Allow_LDAPS_Tcp_Inbound"
      access                     = "Allow"
      destination_address_prefix = module.virtualnetwork.subnets[local.subnet_names.domain_controller].resource.body.properties.addressPrefixes[0]
      destination_port_ranges    = ["636"]
      direction                  = "Inbound"
      priority                   = 225
      protocol                   = "Tcp"
      source_address_prefix      = module.virtualnetwork.subnets[local.subnet_names.domain_member].resource.body.properties.addressPrefixes[0]
      source_port_range          = "*"
    }
    "Allow_LDAP_Udp_Inbound" = {
      name                       = "Allow_LDAP_Udp_Inbound"
      access                     = "Allow"
      destination_address_prefix = module.virtualnetwork.subnets[local.subnet_names.domain_controller].resource.body.properties.addressPrefixes[0]
      destination_port_ranges    = ["389"]
      direction                  = "Inbound"
      priority                   = 230
      protocol                   = "Udp"
      source_address_prefix      = module.virtualnetwork.subnets[local.subnet_names.domain_member].resource.body.properties.addressPrefixes[0]
      source_port_range          = "*"
    }
    "Allow_LDAP_GC_Tcp_Inbound" = {
      name                       = "Allow_LDAP_GC_Tcp_Inbound"
      access                     = "Allow"
      destination_address_prefix = module.virtualnetwork.subnets[local.subnet_names.domain_controller].resource.body.properties.addressPrefixes[0]
      destination_port_ranges    = ["3268"]
      direction                  = "Inbound"
      priority                   = 235
      protocol                   = "Tcp"
      source_address_prefix      = module.virtualnetwork.subnets[local.subnet_names.domain_member].resource.body.properties.addressPrefixes[0]
      source_port_range          = "*"
    }
    "Allow_LDAPS_GC_Tcp_Inbound" = {
      name                       = "Allow_LDAPS_GC_Tcp_Inbound"
      access                     = "Allow"
      destination_address_prefix = module.virtualnetwork.subnets[local.subnet_names.domain_controller].resource.body.properties.addressPrefixes[0]
      destination_port_ranges    = ["3269"]
      direction                  = "Inbound"
      priority                   = 240
      protocol                   = "Tcp"
      source_address_prefix      = module.virtualnetwork.subnets[local.subnet_names.domain_member].resource.body.properties.addressPrefixes[0]
      source_port_range          = "*"
    }
    "Allow_DNS_Tcp_Inbound" = {
      name                       = "Allow_DNS_Tcp_Inbound"
      access                     = "Allow"
      destination_address_prefix = module.virtualnetwork.subnets[local.subnet_names.domain_controller].resource.body.properties.addressPrefixes[0]
      destination_port_ranges    = ["53"]
      direction                  = "Inbound"
      priority                   = 245
      protocol                   = "Tcp"
      source_address_prefix      = module.virtualnetwork.subnets[local.subnet_names.domain_member].resource.body.properties.addressPrefixes[0]
      source_port_range          = "*"
    }
    "Allow_DNS_Udp_Inbound" = {
      name                       = "Allow_DNS_Udp_Inbound"
      access                     = "Allow"
      destination_address_prefix = module.virtualnetwork.subnets[local.subnet_names.domain_controller].resource.body.properties.addressPrefixes[0]
      destination_port_ranges    = ["53"]
      direction                  = "Inbound"
      priority                   = 250
      protocol                   = "Udp"
      source_address_prefix      = module.virtualnetwork.subnets[local.subnet_names.domain_member].resource.body.properties.addressPrefixes[0]
      source_port_range          = "*"
    }
    "Allow_Kerberos_Tcp_Inbound" = {
      name                       = "Allow_Kerberos_Tcp_Inbound"
      access                     = "Allow"
      destination_address_prefix = module.virtualnetwork.subnets[local.subnet_names.domain_controller].resource.body.properties.addressPrefixes[0]
      destination_port_ranges    = ["88"]
      direction                  = "Inbound"
      priority                   = 255
      protocol                   = "Tcp"
      source_address_prefix      = module.virtualnetwork.subnets[local.subnet_names.domain_member].resource.body.properties.addressPrefixes[0]
      source_port_range          = "*"
    }
    "Allow_Kerberos_Udp_Inbound" = {
      name                       = "Allow_Kerberos_Udp_Inbound"
      access                     = "Allow"
      destination_address_prefix = module.virtualnetwork.subnets[local.subnet_names.domain_controller].resource.body.properties.addressPrefixes[0]
      destination_port_ranges    = ["88"]
      direction                  = "Inbound"
      priority                   = 260
      protocol                   = "Udp"
      source_address_prefix      = module.virtualnetwork.subnets[local.subnet_names.domain_member].resource.body.properties.addressPrefixes[0]
      source_port_range          = "*"
    }
    "Allow_Smb_Tcp_Inbound" = {
      name                       = "Allow_Smb_Tcp_Inbound"
      access                     = "Allow"
      destination_address_prefix = module.virtualnetwork.subnets[local.subnet_names.domain_controller].resource.body.properties.addressPrefixes[0]
      destination_port_ranges    = ["445"]
      direction                  = "Inbound"
      priority                   = 265
      protocol                   = "Tcp"
      source_address_prefix      = module.virtualnetwork.subnets[local.subnet_names.domain_member].resource.body.properties.addressPrefixes[0]
      source_port_range          = "*"
    }
    "Allow_RPC_Dynamic_Tcp_Inbound" = {
      name                       = "Allow_RPC_Dynamic_Tcp_Inbound"
      access                     = "Allow"
      destination_address_prefix = module.virtualnetwork.subnets[local.subnet_names.domain_controller].resource.body.properties.addressPrefixes[0]
      destination_port_ranges    = ["49152-65535"]
      direction                  = "Inbound"
      priority                   = 270
      protocol                   = "Tcp"
      source_address_prefix      = module.virtualnetwork.subnets[local.subnet_names.domain_member].resource.body.properties.addressPrefixes[0]
      source_port_range          = "*"

    }
  }
}

# This is the module call
module "nsg_domain_controller_subnet" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "~> 0.5.0"

  name                = local.resource_names["network_security_group_domain_controller"]
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location

  tags = var.tags

  security_rules = local.nsg_rules_domain_controller_subnet

  enable_telemetry = var.telemetry_enabled
}
