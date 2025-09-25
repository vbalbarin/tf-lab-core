locals {
  subnet_names = {
    gateway             = "GatewaySubnet"
    azure_firewall      = "AzureFirewallSubnet"
    azure_firewall_mgmt = "AzureFirewallManagementSubnet"
    azure_bastion       = "AzureBastionSubnet"
    domain_controller   = "DomainControllerSubnet"
    domain_member       = "DomainMemberSubnet"
    placeholder         = null # Setting the subnet name to null value will skip assignment of CIDR
  }
}

module "subnet_addrs" {
  source  = "hashicorp/subnets/cidr"
  version = "~> 1.0.0"

  base_cidr_block = local.conf_network_resources.vnet_address_space
  networks = [
    {
      name     = local.subnet_names.gateway
      new_bits = 3
    },
    {
      name     = local.subnet_names.placeholder
      new_bits = 3
    },
    {
      name     = local.subnet_names.azure_firewall
      new_bits = 4
    },
    {
      name     = local.subnet_names.azure_firewall_mgmt
      new_bits = 4
    },
    {
      name     = local.subnet_names.placeholder
      new_bits = 4
    },
    {
      name     = local.subnet_names.azure_bastion
      new_bits = 4
    },
    {
      name     = local.subnet_names.domain_controller
      new_bits = 5
    },
    {
      name     = local.subnet_names.domain_member
      new_bits = 5
    },
  ]
}

module "virtualnetwork" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "~> 0.10.0"

  // DO NOT SET DNS IPs HERE

  name                = local.resource_names["virtual_network"]
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location

  address_space = [local.conf_network_resources.vnet_address_space, ]

  subnets = {
    "${local.subnet_names.gateway}" = {
      name             = local.subnet_names.gateway
      address_prefixes = [module.subnet_addrs.network_cidr_blocks[local.subnet_names.gateway]]
      # network_security_group = {
      # }
    }
    "${local.subnet_names.azure_firewall}" = {
      name             = local.subnet_names.azure_firewall
      address_prefixes = [module.subnet_addrs.network_cidr_blocks[local.subnet_names.azure_firewall]]
      # network_security_group = {
      # }
    }
    "${local.subnet_names.azure_firewall_mgmt}" = {
      name             = local.subnet_names.azure_firewall_mgmt
      address_prefixes = [module.subnet_addrs.network_cidr_blocks[local.subnet_names.azure_firewall_mgmt]]
      # network_security_group = {
      # }
    }
    "${local.subnet_names.azure_bastion}" = {
      name             = local.subnet_names.azure_bastion
      address_prefixes = [module.subnet_addrs.network_cidr_blocks[local.subnet_names.azure_bastion]]
      # network_security_group = {
      # }
    }
    "${local.subnet_names.domain_controller}" = {
      name             = local.subnet_names.domain_controller
      address_prefixes = [module.subnet_addrs.network_cidr_blocks[local.subnet_names.domain_controller]]
      network_security_group = {
        id = module.nsg_domain_controller_subnet.resource.id
      }
    }
    "${local.subnet_names.domain_member}" = {
      name             = local.subnet_names.domain_member
      address_prefixes = [module.subnet_addrs.network_cidr_blocks[local.subnet_names.domain_member]]
      network_security_group = {
        id = module.nsg_domain_member_subnet.resource.id
      }
      service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
    }
  }

  enable_telemetry = var.telemetry_enabled

  tags = var.tags
}

# output "vnet_subnets" {
#   value = module.virtualnetwork.subnets
# }

# output "network_cidr_blocks" {
#   value = module.subnet_addrs.network_cidr_blocks
# }

# output "geo_codes" {
#   value = local.geo_codes_by_location
# }