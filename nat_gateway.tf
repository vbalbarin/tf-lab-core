module "nat_gateway" {
  count = var.deploy_natgw ? 1 : 0

  source  = "Azure/avm-res-network-natgateway/azurerm"
  version = "~> 0.2.1"

  name                = local.resource_names["nat_gateway"]
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location
  tags                = var.tags


  // TODO: Make FW assoc conditional on creation of FW
  subnet_associations = {
    # "${local.subnet_names.azure_firewall}" = {
    #   resource_id = module.virtualnetwork.subnets[local.subnet_names.azure_firewall].resource_id
    # }
    "${local.subnet_names.domain_member}" = {
      resource_id = module.virtualnetwork.subnets[local.subnet_names.domain_member].resource_id
    }
    "${local.subnet_names.domain_controller}" = {
      resource_id = module.virtualnetwork.subnets[local.subnet_names.domain_controller].resource_id
    }
  }

  public_ip_configuration = {
    allocation_method = "Static"
    ip_version        = "IPv4"
    sku               = "Standard"
    zones             = ["1", "2", "3"]
  }

  public_ips = {
    ng_pip1 = {
      name = local.resource_names["nat_gateway_public_ip"]
    }
  }

  enable_telemetry = var.telemetry_enabled
}